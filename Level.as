package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.geom.Point;
	import common.Commons;
	import sounds.SoundManager
	
	public class Level extends MovieClip
	{
		//maps
		private var unitLocations:Array;
		private var allyLocation:Array;
		private var enemyLocation:Array
		private var tileList:Array;
		public var mapArray:Array;
		
		//lists
		public var heroesToAdd:Array;
		private var heroList:Array;
		private var enemyList:Array;
		protected var itemList:Array;
		private var enemyAddList:Array;
		
		//classes/objects
		private var victory:Victory;
		public var gameControls:GameControls;
		public var familyData:FamilyData;
		protected var lClass:LClass;
		private var prefs:Preferences;
		private var dialogue:DialogueBox
		
		//vars
		private var mapWidth = 20;
		private var mapHeight = 15;
		private var tileSide = 32;
		public var coinGain:int;
		public var gameProgress:int;
		
		//Booleans
		private var scrappingMap:Boolean;
		public var isLoad:Boolean;

		public function Level(famData:FamilyData, IsALoad:Boolean,ItemList:Array)
		{
			//How to use this class:
			//Call class:
			//Add familyData with loadFamilyValues
			//Add heroes to add before adding as child
			//Call as child

			heroList = new Array  ;
			enemyList = new Array  ;
			heroesToAdd = new Array  ;			
			
			familyData = famData;
			
			mapArray = lClass.mapArray;
			gameProgress = lClass.gameProgress;
			enemyAddList = lClass.runEnemies();
			heroesToAdd = lClass.runAllies(familyData);

			coinGain = lClass.coinGain;
			
			unitLocations = new Array;
			
			allyLocation = new Array;
			enemyLocation = new Array;
			tileList = new Array;
			for (var i:int=0; i < mapHeight; i++)
			{
				unitLocations.push(new Array);
				allyLocation.push(new Array);
				enemyLocation.push(new Array);
				tileList.push(new Array);
				for (var o:int=0; o < mapWidth; o++)
				{
					unitLocations[i].push(null);
					allyLocation[i].push(null);
					enemyLocation[i].push(null);
					tileList[i].push(null);
				}
			}
			

			itemList = ItemList;
			isLoad = IsALoad;
			addEventListener(Event.ADDED_TO_STAGE, doMakeMap);
			addEventListener("doneMoving", doneMoving);
			addEventListener("moving", startedMoving);
			

			// constructor code
		}
		private function doneMoving(e:Event):void
		{
			gameControls.heroMoving = false;
			gameControls.doneMoving();
		}
		private function startedMoving(e:Event):void
		{
			gameControls.heroMoving = true;
			gameControls.removeMenu();
		}

		private function doMakeMap(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, doMakeMap);

			//SoundManager.bgfx("battle");
			makeMap();
			prefs = new Preferences(heroesToAdd,itemList,familyData)
			parent.addChild(prefs);
			prefs.x = stage.width - prefs.width
			if (isLoad == true)
			{

			}
			else if (isLoad == false)
			{
				initGameControls();
				addHeroes();
				addEnemies();
				startDialogue();
			}
			addEventListener("eDead",enemyDead);
			addEventListener("dead",heroDead);
		}
		private function startDialogue():void
		{
			dialogue = new DialogueBox(lClass.dialArray);
			addChild(dialogue)
			dialogue.addEventListener(Event.REMOVED_FROM_STAGE, startLoadUp)
		}
		private function startLoadUp(e:Event):void
		{
			trace("removed from stage")
			dialogue.removeEventListener(Event.REMOVED_FROM_STAGE, startLoadUp)
			loadUp();
		}
		public function initGameControls():void
		{
			gameControls = new GameControls(this,mapArray,tileList,allyLocation,heroList,enemyLocation,enemyList,tileSide,mapWidth,mapHeight,familyData,itemList,unitLocations);
			addChild(gameControls);
		}
		public function loadUp():void
		{
			gameControls.loadUp();
		}
		public function scrapMap():void
		{
			scrappingMap = true;
			while (heroList.length > 0)
			{
				if (this.contains(heroList[0]))
				{
					removeChild(heroList[0]);
				}
				heroList.shift();
			}
			while (enemyList.length > 0)
			{
				removeChild(enemyList[0]);
				enemyList.shift();
			}
			for (var k:int=0; k<tileList.length; k++)
			{
				for (var p:int=0; p <tileList[k].length; p++)
				{
					removeChild(tileList[k][p]);
					if (tileList[k][p] is Trees)
					{
						removeChild(tileList[k][p].backgroundTile);
						tileList[k][p].backgroundTile = null;
					}
					tileList[k][p] = null;
					
				}
			}
			for (var i:int=0; i < mapHeight; i++)
			{
				unitLocations.push(new Array);
				
				allyLocation.push(new Array);
				enemyLocation.push(new Array);
				tileList.push(new Array);
				for (var o:int=0; o < mapWidth; o++)
				{
					unitLocations[i].push(null);
					
					allyLocation[i].push(null);
					enemyLocation[i].push(null);
					tileList[i].push(null);
				}
			}
		}
		public function makeMap():void
		{
			for (var i:int = 0; i < mapHeight; i++)
			{
				for (var u:int = 0; u < mapWidth; u++)
				{
					var gr:grass;
					if (mapArray[i][u] == 0 || mapArray[i][u] == 6)
					{
						gr = new grass(u,i);
						gr.x = tileSide * u;
						gr.y = tileSide * i;
						addChildAt(gr,0);
						tileList[i][u] = gr;
						if (mapArray[i][u] == 6)
						{
							var tr:Trees = new Trees(u,i);
							tr.backgroundTile = tileList[i][u];
							tr.x = tileSide * u;
							tr.y = tileSide * i;
							addChildAt(tr,1);
							tileList[i][u] = tr;
						}
					}
					else if (mapArray[i][u] == 1)
					{
						var st:Stone = new Stone(u,i);
						st.x = tileSide * u;
						st.y = tileSide * i;
						addChildAt(st,0);
						tileList[i][u] = st;
					}
					else if (mapArray[i][u] == 2)
					{
						var mt:Mountain = new Mountain(u,i);
						mt.x = tileSide * u;
						mt.y = tileSide * i;
						addChildAt(mt,0);
						tileList[i][u] = mt;
					}
					else if (mapArray[i][u] == 3)
					{
						var cto:CastleTower = new CastleTower(u,i);
						cto.x = tileSide * u;
						cto.y = tileSide * i;
						addChildAt(cto,0);
						tileList[i][u] = cto;
					}
					else if (mapArray[i][u] == 4)
					{
						var dt:Dirt = new Dirt(u,i);
						dt.x = tileSide * u;
						dt.y = tileSide * i;
						addChildAt(dt,0);
						tileList[i][u] = dt;
					}
					/*if (buildingArray[i][u] != null)
					{
						if (buildingArray[i][u] == 23)
						{
							var hpBase:HealingBase = new HealingBase();
							hpBase.x = u * tileSide;
							hpBase.y = i * tileSide;
							buildingArray[i][u] = hpBase;
							addChild(hpBase);
						}
						else if (buildingArray[i][u] == 24)
						{
							var armr:Armorer = new Armorer();
							armr.x = u * tileSide;
							armr.y = i * tileSide;
							buildingArray[i][u] = armr;
							addChild(armr);
						}
						else if (buildingArray[i][u] == 25)
						{
							var charter:Charter = new Charter();
							charter.x = u * tileSide;
							charter.y = i * tileSide;
							buildingArray[i][u] = charter;
							addChild(charter);
						}
						else if (buildingArray[i][u] == 26)
						{
							var barracks:Barracks = new Barracks();
							barracks.x = u * tileSide;
							barracks.y = i * tileSide;
							buildingArray[i][u] = barracks;
							addChild(barracks);
						}
						else if (buildingArray[i][u] == 27)
						{
							var infr:Infirmary = new Infirmary();
							infr.x = u * tileSide;
							infr.y = i * tileSide;
							buildingArray[i][u] = infr;
							addChild(infr);
						}
						else if (buildingArray[i][u] == 28)
						{
							var pub:Pub = new Pub();
							pub.x = u * tileSide;
							pub.y = i * tileSide;
							buildingArray[i][u] = pub;
							addChild(pub);
						}
					}*/
				}
			}
		}
		public function addHeroes():void
		{
			for (var i:int =0; i < heroesToAdd.length; i++)
			{
				if (isLoad == false)
				{
				heroesToAdd[i].cHp = heroesToAdd[i].cMaxHp;
				heroesToAdd[i].cMove = heroesToAdd[i].cMoveMax;
				}
				addHero(heroesToAdd[i]);
			}
		}
		protected function addEnemies():void
		{
			for (var i:int=0; i < enemyAddList.length; i++)
			{
				addEnemy(enemyAddList[i])
			}
			enemyAddList = null;
		}
		public function addEnemy(NewEnemy:*):void
		{
			var newEnemy:* = NewEnemy;
			addChildAt(newEnemy,getChildIndex(gameControls));
			tileList[newEnemy.yCo][newEnemy.xCo].occupied = true;
			enemyLocation[newEnemy.yCo][newEnemy.xCo] = newEnemy;
			newEnemy.addEventListener(Event.REMOVED,enemyRemoved,false,0,true);
			unitLocations[newEnemy.yCo][newEnemy.xCo] = newEnemy;
			enemyList.push(newEnemy);

		}
		private function heroMouseClick(e:MouseEvent):void
		{
			if (gameControls != null && gameControls.isGameLocked() == false)
			{
				if (gameControls.playerSelected != heroList.indexOf(e.target.parent) && gameControls.menuOpen == true)
				{
					gameControls.removeMenu()
				}
				gameControls.playerSelected = heroList.indexOf(e.target.parent);
				gameControls.actionsPanel();
			}
		}
		private function heroDead(e:Event):void
		{
			var hero:* = e.target
			removeChild(hero)
			
			e.target.backdrop.removeEventListener(MouseEvent.CLICK,heroMouseClick);
			tileList[e.target.yCo][e.target.xCo].occupied = false;
			allyLocation[e.target.yCo][e.target.xCo] = null;
			unitLocations[e.target.yCo][e.target.xCo] = null;
			
			var heroSelected:int = heroList.indexOf(e.target)
			heroList.splice(heroList.indexOf(e.target), 1);
			
			if (heroSelected == gameControls.playerSelected)
			{
				
				if (gameControls.playerSelected - 1 >= 0)
				{
					
					gameControls.playerSelected--;
				}
			}
			
			if (heroList.length == 0)
			{
				gameControls.turnOffControls();
				
				var gameOver:GameOver = new GameOver(heroesToAdd,itemList,familyData);
				gameOver.x = 120;
				gameOver.y = 70
				addChild(gameOver);
			}
		}
		public function addHero(NewChar:*):void
		{
			var newChar:* = NewChar;
			if (newChar.cHp > 0)
			{
				if (!(this.contains(newChar)))
				{
					addChildAt(newChar,getChildIndex(gameControls));
					
				}
				else
				{
					newChar.visible = true;
				}
				newChar.backdrop.addEventListener(MouseEvent.CLICK,heroMouseClick);
				tileList[newChar.yCo][newChar.xCo].occupied = true;
				allyLocation[newChar.yCo][newChar.xCo] = newChar;
				unitLocations[newChar.yCo][newChar.xCo] = newChar;
				newChar.x = newChar.xCo * tileSide;
				newChar.y = newChar.yCo * tileSide;
			}
			if (heroList.indexOf(newChar) == -1)
			{
				heroList.push(newChar);
			}
			trace("added")
		}
		private function enemyRemoved(e:Event):void
		{
			e.currentTarget.removeEventListener(Event.REMOVED,enemyRemoved);
			enemyLocation[e.currentTarget.yCo][e.currentTarget.xCo] = null;
			tileList[e.currentTarget.yCo][e.currentTarget.xCo].occupied = false;
			enemyList.splice(enemyList.indexOf(e.currentTarget), 1);
			unitLocations[e.target.yCo][e.target.xCo] = null;
			if (enemyList.length == 0 && scrappingMap == false)
			{

				victory = new Victory(familyData,this);
				victory.addEventListener(Event.REMOVED, victoryRemoved);
				addChild(victory);
			}
		}
		private function victoryRemoved(e:Event):void
		{
			loadGameMap()
		}
		public function loadGameMap():void
		{
			var gameMap:GameMap = new GameMap(familyData,itemList)
			var mainParent:* = parent;
			while (!(mainParent is Main))
			{
				mainParent = mainParent.parent;
			}
			mainParent.loadChild(gameMap);
			goExit();
		}
		private function enemyDead(e:Event):void
		{
			var enemy:* = e.target;
			removeChild(enemy);

		}
		public function goExit():void
		{
			scrapMap();

			prefs.doExit();
			parent.removeChild(prefs)
			prefs = null;
			
			removeEventListener("dead",heroDead);
			removeEventListener("eDead", enemyDead);
			removeEventListener("doneMoving", doneMoving);
			removeEventListener("moving", startedMoving);
			itemList = null;

			if (this.contains(gameControls))
			{
				gameControls.goExit();
			}
			gameControls = null;
			
			allyLocation = null;
			enemyLocation = null;
			unitLocations = null;
			
			heroesToAdd = null;

			familyData = null;
			tileList = null;
			heroList = null;
			enemyList = null;
			
			dialogue = null;

			parent.removeChild(this);
		}
	}
}