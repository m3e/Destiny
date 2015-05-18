package 
{
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.display.Shape;
	import flash.display.Sprite;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.net.SharedObject;
	import sounds.SoundManager;
	import flash.events.MouseEvent;
	import com.greensock.TweenMax;
	import flash.geom.Point;
	import common.Commons;

	public class GameControls extends MovieClip
	{
		//Screens || Popups
		private var charScreen:CharBattleStats;
		private var battleFrame:BattleFrame;
		private var selectedBox:selectBox;
		private var menu:menubox;
		//unused screens
		private var shopWindow:ShopWindow;
		private var pubWindow:PubWindow;
		private var infirmWindow:InfirmWindow;
		private var barracksWindow:BarracksWindow;
		private var charterWindow:CharterWindow;

		//Mechanics
		private var assessGround:AssessGround;
		private var familyData:FamilyData;

		//Values
		private var level:Object;
		private var tileSide:int;
		private var mapWidth:int;
		private var mapHeight:int;
		public var playerSelected:int;
		private var enemiesTurn:int;

		//Maps
		public var mapArray:Array;
		public var tileList:Array;
		public var allyLocation:Array;
		private var unitLocations:Array;
		public var enemyLocation:Array;

		//Lists
		private var heroList:Array;
		private var enemyList:Array;
		private var itemList:Array;

		//gamelocking booleans
		private var endTurnKeyLock:Boolean;
		private var charScreenOpen:Boolean;
		public var heroMoving:Boolean;
		public var menuOpen:Boolean;
		private var heroAttacking:Boolean;
		//Clarifying booleans
		private var doingAttack:Boolean;
		private var turnedOn:Boolean;
		private var gameOn:Boolean;
		//notused booleans
		private var shopOpen:Boolean;
		private var shopWinOpen:Boolean;
		private var pubWinOpen:Boolean;
		private var infirmWinOpen:Boolean;
		private var barracksWinOpen:Boolean;
		private var charterWinOpen:Boolean;


		//n trackMouse()
		private var currentX:int;
		private var currentY:int;

		//Colored Sqs
		private var redSqs:Array;
		private var greenSqs:Array;
		public var blueSqs:Array;
		private var atkSqs:Array;

		//Tween related
		private var myTween1:Tween;
		private var myTween2:Tween;
		private var geo:Sprite;
		private var leo:Sprite;
		private var tweenList:Array;

		public function GameControls(Level:Object, maparray:Array, tilelist:Array, allylocation:Array, herolist:Array, enemylocation:Array, enemylist:Array, tileside:int, mapwidth:int, mapheight:int,FamData:FamilyData, ItemList:Array,UnitLocations:Array)
		{
			tweenList = new Array  ;
			redSqs = new Array  ;
			greenSqs = new Array  ;
			blueSqs = new Array  ;
			atkSqs = new Array  ;

			unitLocations = UnitLocations;
			itemList = ItemList;
			familyData = FamData;
			level = Level;
			mapWidth = mapwidth;
			mapHeight = mapheight;
			tileSide = tileside;
			mapArray = maparray;
			tileList = tilelist;
			allyLocation = allylocation;
			heroList = herolist;
			enemyLocation = enemylocation;
			enemyList = enemylist;
			playerSelected = 0;
			menu = new menubox  ;
			addEventListener(Event.ADDED_TO_STAGE, listen, false, 0, true);
		}
		public function isGameLocked():Boolean
		{
			var isLocked:Boolean;
			if (endTurnKeyLock == true || charScreenOpen == true || heroMoving == true || turnedOn == false)
			{
				isLocked = true;
			}
			return isLocked;
		}
		private function removeBlueSqs():void
		{
			while (blueSqs.length != 0)
			{
				level.removeChild(blueSqs[0]);
				blueSqs.splice(0,1);
			}
		}
		private function removeRedSqs():void
		{
			while (redSqs.length != 0)
			{
				level.removeChild(redSqs[0]);
				redSqs.splice(0,1);
			}
		}
		private function removeGreenSqs():void
		{
			while (greenSqs.length != 0)
			{
				level.removeChild(greenSqs[0]);
				greenSqs.splice(0,1);
			}
		}
		private function removeAtkSqs():void
		{
			while (atkSqs.length > 0)
			{
				level.removeChild(atkSqs[0]);
				atkSqs.splice(0,1);
			}
		}
		public function removeMenu():void
		{

			//Destroy red sqs
			removeRedSqs();
			//Destroy green sqs
			removeGreenSqs();
			//Destroy blue sqs
			removeBlueSqs();
			//Destroy atk sqs
			removeAtkSqs();

			level.removeChild(selectedBox);
			level.removeChild(menu);
			menuOpen = false;
			trackMouse();
			heroAttacking = false;
		}
		private function listen(e:Event):void
		{
			stage.addEventListener("hpBarUpdate",updateHpBar, false, 0, true);
			removeEventListener(Event.ADDED_TO_STAGE, listen);
		}
		public function loadUp():void
		{
			stage.addEventListener(KeyboardEvent.KEY_UP,keyUpCheck);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownCheck);
			turnedOn = true;

			battleFrame = new BattleFrame();
			for (var i:int=0; i<heroList.length; i++)
			{
				battleFrame.setHpBar(i,heroList[i]);
				battleFrame.setApText(i,heroList[i]);
			}
			//level.addChildAt(battleFrame,level.getChildIndex(this));
		}
		public function turnOffControls():void
		{
			if (turnedOn == true)
			{
				turnedOn = false;
				stage.removeEventListener(KeyboardEvent.KEY_UP,keyUpCheck);
				stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDownCheck);
			}
		}
		private function openMenu():void
		{
			//Create selectedBox;
			selectedBox = new selectBox(heroList[playerSelected].xCo,heroList[playerSelected].yCo);
			menu.xBox.text = selectedBox.xCo.toString();
			menu.yBox.text = selectedBox.yCo.toString();
			level.addChild(selectedBox);
		}
		private function makeSq(color:uint,cAlpha:Number,xCo:int,yCo:int):Sprite
		{
			var newSq:Sprite = new Sprite();
			newSq.mouseEnabled = false;
			newSq.mouseChildren = false;
			newSq.graphics.beginFill(color,cAlpha);
			newSq.graphics.drawRect(0,0,tileSide,tileSide);
			newSq.x = xCo * tileSide;
			newSq.y = yCo * tileSide;
			newSq.graphics.endFill();
			level.addChild(newSq);
			return newSq;
		}
		public function actionsPanel():void
		{
			if (isGameLocked() == false && menuOpen == false)
			{
				openMenu();
				if (enemyList.length > 0 && gameOn == false)
				{
					//make blue Sq
					blueSqs.push(makeSq(0x0000FF,0.4,selectedBox.xCo,selectedBox.yCo));

					//figure out movable blocks
					var dijkPath:DijkPath = new DijkPath(heroList[playerSelected],mapArray,unitLocations);
					var closedList:Array = dijkPath.getClosedList();
					dijkPath.doExit();
					//creates the red squares;
					closedList.sortOn("dist", Array.NUMERIC);
					closedList.splice(0,1);
					var nN:DijkNode;
					for (var qx:int=0; qx < closedList.length; qx++)
					{
						nN = closedList[qx];
						if (!(allyLocation[nN.yCo][nN.xCo] is Hero))
						{
							redSqs.push(makeSq(0xFF0000,0.5,nN.xCo,nN.yCo));
						}
					}
					displayAtks();
				}
				getMenu();
			}
			else if (menuOpen == true && charScreenOpen == false)
			{
				removeMenu();
			}
		}
		private function keyUpCheck(e:KeyboardEvent):void
		{

			a = 0;
			var oldX:int;
			var oldY:int;
			var newX:int;
			var newY:int;
			var a:int = 0;

			/*if (e.keyCode == Keyboard.C)
			{
			if (charScreenOpen == true)
			{
			charScreenOpen = false;
			for (var iG:int=0; iG<heroList.length; iG++)
			{
			updateHeroBars(iG,heroList[iG]);
			}
			charScreen.goExit();
			}
			else if (charScreenOpen == false)
			{
			charScreen = new CharBattleStats(familyData,heroList[playerSelected]);
			level.addChild(charScreen);
			charScreenOpen = true;
			charScreen.addEventListener(Event.REMOVED, charRemoved, false, 0, true);
			}
			
			}*/
			if (e.keyCode == Keyboard.SPACE)
			{
				actionsPanel();
			}
			else if ((menuOpen == true))
			{

				if (charScreenOpen == false)
				{
					if (e.keyCode == Keyboard.M)
					{
						if (heroAttacking == false)
						{
							moveAttack();
						}
						else if (Math.floor(blueSqs[1].x/32) == selectedBox.xCo && Math.floor(blueSqs[1].y/32) == selectedBox.yCo)
						{
							heroMove(selectedBox.xCo,selectedBox.yCo);
						}
					}
					else
					{
						a = 0;
						oldX = selectedBox.xCo;
						oldY = selectedBox.yCo;
						newX = oldX;
						newY = oldY;


						if (e.keyCode == Keyboard.RIGHT && oldX + 1 < mapWidth)
						{
							a++;
							newX++;
						}
						else if (e.keyCode == Keyboard.LEFT && oldX - 1 >= 0)
						{
							a++;
							newX--;
						}
						else if (e.keyCode == Keyboard.DOWN && oldY + 1 < mapHeight)
						{
							a++;
							newY++;
						}
						else if (e.keyCode == Keyboard.UP && oldY -1 >= 0)
						{
							a++;
							newY--;
						}
						if (a == 1)
						{
							if (heroAttacking == false)
							{
								moveSelectedBox(newX,newY);
							}
							else if (heroAttacking == true)
							{
								moveAttackSelectedBox(newX,newY);
							}
						}
						if (e.keyCode == Keyboard.A && (heroAttacking == true || heroList[playerSelected].attacksLeft > 0) && enemyLocation[selectedBox.yCo][selectedBox.xCo] is Enemy)
						{
							var distance:int = Commons.dist(heroList[playerSelected].xCo,heroList[playerSelected].yCo,selectedBox.xCo,selectedBox.yCo)
							
							if (distance <= heroList[playerSelected].atkRange)
							{
							doAtk();
							}
						}
						else if (e.keyCode == Keyboard.D)
						{
							doDefend();
						}
						else if (e.keyCode == Keyboard.NUMBER_1)
						{
							dropThings(1);
						}
						else if (e.keyCode == Keyboard.NUMBER_2)
						{
							dropThings(2);
						}
						else if (e.keyCode == Keyboard.NUMBER_3)
						{
							dropThings(3);
						}
						else if (e.keyCode == Keyboard.NUMBER_4)
						{
							dropThings(4);
						}
						else if (e.keyCode == Keyboard.NUMBER_6)
						{
							dropThings(6);
						}
						else if (e.keyCode == Keyboard.E)
						{
							if (level.contains(menu))
							{
								assessGround = new AssessGround(mapWidth,mapHeight,mapArray,enemyList,tileList,enemyLocation,allyLocation,unitLocations);
								addChild(assessGround);
								endTurn();
								removeMenu();
							}
						}
						else if (e.keyCode == Keyboard.G)
						{
							if (unitLocations[selectedBox.yCo][selectedBox.xCo] == null)
							{
								generateEnemies();
							}
						}
						else if (e.keyCode == Keyboard.J)
						{
							if (unitLocations[selectedBox.yCo][selectedBox.xCo] == null)
							{
								generateHeroes();
							}

						}
					}
				}
				if (e.keyCode == Keyboard.H)
				{
					var h:int = 0;
					if (gameOn == false)
					{
						trace("GodMode");
						gameOn = true;
						for (h; h < heroList.length; h++)
						{

							heroList[h].cHp = 999;
							heroList[h].cMove = 999;
							heroList[h].cAtk = 999;
							heroList[h].cDef = 20;
							heroList[h].stone = 999;
							battleFrame.setApText(h,heroList[h]);
							battleFrame.setHpBar(h,heroList[h]);
						}

					}
					else
					{
						trace("BattleMode");
						gameOn = false;
						for (h; h < heroList.length; h++)
						{

							heroList[h].cHp = heroList[h].cMaxHp;
							heroList[h].cMove = heroList[h].cMoveMax;
							heroList[h].stone = 2;
							heroList[h].refreshStats();
							battleFrame.setApText(h,heroList[h]);
							battleFrame.setHpBar(h,heroList[h]);

						}
					}
				}
			}
		}
		private function tryMovement():Boolean
		{
			var tryMovement:Boolean;
			if (tileList[selectedBox.yCo][selectedBox.xCo].occupied != true && mapArray[selectedBox.yCo][selectedBox.xCo] != 1)
			{
				var pathfind:Path = new Path(heroList[playerSelected],selectedBox.xCo,selectedBox.yCo,mapArray,unitLocations);
				var myPath:Array = pathfind.getPath();
				var movePath:Array = myPath;
				pathfind.goExit();
				if (movePath.length > 0 && movePath[movePath.length - 1].moveCost <= heroList[playerSelected].cMove)
				{
					tryMovement = true;
				}
			}
			return tryMovement;
		}
		private function mouseHeroMove(e:MouseEvent):void
		{
			heroMove(blueSqs[1].x/32,blueSqs[1].y/32);
		}
		private function heroMove(xCo:int,yCo:int):void
		{
			heroList[playerSelected].movement(tileList, allyLocation,xCo,yCo, mapArray,unitLocations);
			battleFrame.setApText(playerSelected,heroList[playerSelected]);
		}
		private function mouseMoveAttack(e:MouseEvent):void
		{
			mouseMovement();
			moveAttack();
		}
		private function moveAttack():void
		{
			//tryMovement just checks if the space is accessible and useable
			if (tryMovement() == true && heroAttacking == false)
			{
				removeAtkSqs();
				removeRedSqs();
				removeGreenSqs();
				var blueSq:Sprite = makeSq(0x0000FF,0.4,selectedBox.xCo,selectedBox.yCo);
				blueSqs.push(blueSq);
				blueSq.addEventListener(MouseEvent.CLICK, mouseHeroMove,false,0,true);
				blueSq.mouseEnabled = true;
				blueSq.mouseChildren = true;
				heroAttacking = true;

				displayAtks();

			}
		}
		private function mouseDoAtk(e:MouseEvent):void
		{
			if (enemyLocation[Math.floor(mouseY / 32)][Math.floor(mouseX / 32)] is Enemy)
			{
				mouseMovement();
				trackMouseOff();
				doAtk();
			}
		}
		private function displayAtks():void
		{
			if (heroList[playerSelected].attacksLeft > 0)
			{
				var atkRange:int = heroList[playerSelected].atkRange;
				var distance:int = 0;
				for (var i:int = -atkRange; i <= atkRange; i++)
				{
					for (var o:int= -atkRange; o <= atkRange; o++)
					{
						distance = Math.abs(i) + Math.abs(o);
						if (distance <= atkRange && distance != 0)
						{
							var sQ:Sprite = makeSq(0xFFFFFF,0.4,selectedBox.xCo + i,selectedBox.yCo + o);
							atkSqs.push(sQ);
							sQ.addEventListener(MouseEvent.CLICK, mouseDoAtk,false,0,true);
							sQ.mouseEnabled = true;
							sQ.mouseChildren = true;
							TweenMax.to(sQ,.7,{repeat:-1,alpha:.2,yoyo:true});
						}
					}
				}
			}
		}
		private function generateEnemies():void
		{
			var enemy:Enemy;
			enemy = new Enemy(selectedBox.xCo,selectedBox.yCo);
			level.addEnemy(enemy);

		}
		private function generateHeroes():void
		{
			var character:Spec;
			character = new Spec(familyData,false);
			character.xCo = selectedBox.xCo;
			character.yCo = selectedBox.yCo;
			level.addHero(character);
		}
		private function updateNeat(newArray:Array):Array
		{

			var neatArray:Array = new Array  ;
			for (var o:int = 0; o < newArray.length; o++)
			{
				var content:* = newArray[o];
				if (content is Array)
				{
					neatArray[o] = updateNeat(content);
				}
				else
				{
					neatArray[o] = content;
				}

				/*for (var v:int = 0; v < mapArray[o].length; v++)
				{
				neatArray[o][v] = mapArray[o][v];
				}*/
			}





			return neatArray;
			//ended
		}
		private function dropStone():void
		{
			if (heroList[playerSelected].stone > 0 && mapArray[selectedBox.yCo][selectedBox.xCo] == 0)
			{
				mapArray[selectedBox.yCo][selectedBox.xCo] = 1;
				level.removeChild(tileList[selectedBox.yCo][selectedBox.xCo]);
				var st:Stone = new Stone(selectedBox.xCo,selectedBox.yCo);
				st.x = tileSide * selectedBox.xCo;
				st.y = tileSide * selectedBox.yCo;
				level.addChildAt(st,0);
				tileList[selectedBox.yCo][selectedBox.xCo] = st;
				heroList[playerSelected].stone -=  1;

			}
		}
		private function dropMountain():void
		{
			if (heroList[playerSelected].stone > 0 && mapArray[selectedBox.yCo][selectedBox.xCo] == 0)
			{
				mapArray[selectedBox.yCo][selectedBox.xCo] = 2;
				level.removeChild(tileList[selectedBox.yCo][selectedBox.xCo]);
				var mt:Mountain = new Mountain(selectedBox.xCo,selectedBox.yCo);
				mt.x = tileSide * selectedBox.xCo;
				mt.y = tileSide * selectedBox.yCo;
				level.addChildAt(mt,0);
				tileList[selectedBox.yCo][selectedBox.xCo] = mt;
				heroList[playerSelected].stone -=  1;
				trace(heroList[playerSelected].stone);
			}
		}
		private function dropTrees():void
		{
			if (mapArray[selectedBox.yCo][selectedBox.xCo] == 0)
			{
				mapArray[selectedBox.yCo][selectedBox.xCo] = 6;
				level.removeChild(tileList[selectedBox.yCo][selectedBox.xCo]);
				var tr:Trees = new Trees(selectedBox.xCo,selectedBox.yCo);
				tr.x = tileSide * selectedBox.xCo;
				tr.y = tileSide * selectedBox.yCo;
				level.addChildAt(tr,0);
				var gr:grass = new grass(selectedBox.xCo,selectedBox.yCo);
				tr.backgroundTile = gr;
				gr.x = tileSide * selectedBox.xCo;
				gr.y = tileSide * selectedBox.yCo;
				level.addChildAt(gr,0);
				tileList[selectedBox.yCo][selectedBox.xCo] = tr;
			}
		}
		private function dropDirt():void
		{
			if (mapArray[selectedBox.yCo][selectedBox.xCo] == 0)
			{
				mapArray[selectedBox.yCo][selectedBox.xCo] = 4;
				level.removeChild(tileList[selectedBox.yCo][selectedBox.xCo]);
				var dt:Dirt = new Dirt(selectedBox.xCo,selectedBox.yCo);
				dt.x = tileSide * selectedBox.xCo;
				dt.y = tileSide * selectedBox.yCo;
				level.addChildAt(dt,0);
				tileList[selectedBox.yCo][selectedBox.xCo] = dt;
			}
		}
		private function dropFort():void
		{
			if (heroList[playerSelected].stone > 0 && mapArray[selectedBox.yCo][selectedBox.xCo] == 0)
			{
				mapArray[selectedBox.yCo][selectedBox.xCo] = 3;
				level.removeChild(tileList[selectedBox.yCo][selectedBox.xCo]);
				var cto:CastleTower = new CastleTower(selectedBox.xCo,selectedBox.yCo);
				cto.x = tileSide * selectedBox.xCo;
				cto.y = tileSide * selectedBox.yCo;
				level.addChildAt(cto,0);
				tileList[selectedBox.yCo][selectedBox.xCo] = cto;
				heroList[playerSelected].stone -=  1;
				trace(heroList[playerSelected].stone);
			}
		}
		private function endTurn():void
		{
			for (var i:int; i<heroList.length; i++)
			{
				heroList[i].xCo = heroList[i].x / tileSide;
				heroList[i].yCo = heroList[i].y / tileSide;
				allyLocation[heroList[i].yCo][heroList[i].xCo] = heroList[i];
			}
			endTurnKeyLock = true;

			assessGround.startAssessment();
			initEnemyTurn();
		}
		private function updateHpBar(e:Event):void
		{
			updateHeroBars(heroList.indexOf(e.target),e.target);
		}
		public function updateHeroBars(i:int,Hero:Object)
		{
			battleFrame.setApText(i,Hero);
			battleFrame.setHpBar(i,Hero);
		}
		private function doDefend():void
		{
			heroList[playerSelected].defend();

			heroList[playerSelected].cMove = 0;

			battleFrame.setApText(playerSelected,heroList[playerSelected]);

			removeMenu();
		}
		public function doneMoving():void
		{
			if (doingAttack == true)
			{
				doingAttack = false;
				var enemyTarget:MovieClip = enemyLocation[selectedBox.yCo][selectedBox.xCo];
				heroList[playerSelected].attacksLeft--;
				//Play the sound
				SoundManager.sfx("swordhit");

				trace("Atk: ",heroList[playerSelected].cAtk);
				trace("eDmgTaken: ",enemyTarget.calcPhysDmg(heroList[playerSelected].cAtk));
				trace("eHp: ",enemyTarget.eHp);
				//Check for death
				if (enemyTarget.eHp - enemyTarget.calcPhysDmg(heroList[playerSelected].cAtk) > 0)
				{
					returnDmg(enemyTarget.eReturnDmg);
				}
				else
				{
					familyData.coin +=  enemyTarget.coinGain;
					heroList[playerSelected].monstersKilled++;
					heroList[playerSelected].experience +=  enemyTarget.xpGain;
					battleFrame.eHpBar.scaleX = 0;
				}

				//Give damage to enemy
				enemyTarget.takeDmg(heroList[playerSelected].cAtk);

				var percentHp:Number = enemyTarget.eHp / enemyTarget.eMaxHp;
				if (percentHp < 0)
				{
					percentHp = 0;
				}
				//Update bars
				battleFrame.eHpBar.scaleX = percentHp;
				battleFrame.setApText(playerSelected,heroList[playerSelected]);

				if (enemyList.length == 0)
				{
					goExit();
				}
			}
			if (menuOpen == true)
			{
				removeMenu();
			}
		}
		private function doAtk():void
		{

			if (heroList[playerSelected].attacksLeft > 0)
			{
				
				doingAttack = true;
				if (heroAttacking == true)
				{
					heroMove(blueSqs[1].x/32,blueSqs[1].y/32);
				}
				else
				{
					
					doneMoving();
				}
			}
			else
			{
				if (heroList[playerSelected].cMove > 0)
				{
					var gr:grass = new grass(selectedBox.xCo,selectedBox.yCo);
					if (mapArray[selectedBox.yCo][selectedBox.xCo] == 1 || mapArray[selectedBox.yCo][selectedBox.xCo] == 2 || mapArray[selectedBox.yCo][selectedBox.xCo] == 3)
					{
						heroList[playerSelected].stone++;
						trace(heroList[playerSelected].stone);
						mapArray[selectedBox.yCo][selectedBox.xCo] = 0;
						level.removeChild(tileList[selectedBox.yCo][selectedBox.xCo]);

						gr.x = tileSide * selectedBox.xCo;
						gr.y = tileSide * selectedBox.yCo;
						level.addChildAt(gr,0);
						tileList[selectedBox.yCo][selectedBox.xCo] = gr;
					}
					else if (mapArray[selectedBox.yCo][selectedBox.xCo] == 4)
					{
						mapArray[selectedBox.yCo][selectedBox.xCo] = 0;
						level.removeChild(tileList[selectedBox.yCo][selectedBox.xCo]);

						gr.x = tileSide * selectedBox.xCo;
						gr.y = tileSide * selectedBox.yCo;
						level.addChildAt(gr,0);
						tileList[selectedBox.yCo][selectedBox.xCo] = gr;
					}
					else if (mapArray[selectedBox.yCo][selectedBox.xCo] == 6)
					{
						mapArray[selectedBox.yCo][selectedBox.xCo] = 0;
						level.removeChild(tileList[selectedBox.yCo][selectedBox.xCo]);
						tileList[selectedBox.yCo][selectedBox.xCo] = tileList[selectedBox.yCo][selectedBox.xCo].backgroundTile;
					}
				}
			}

		}
		private function returnDmg(returnedDmg:int):void
		{
			heroList[playerSelected].returnDmg(returnedDmg);
		}
		public function initEnemyTurn()
		{
			enemiesTurn = 0;

			if (enemyList.length > 0)
			{

				stage.addEventListener("next", nextEnemy, false, 0, true);
				enemyTurn(enemiesTurn);

			}
			else
			{
				afterEndTurn();
			}

		}
		private function afterEndTurn():void
		{
			var p:int;
			for (p=0; p<heroList.length; p++)
			{
				heroList[p].cMove = heroList[p].cMoveMax;
				heroList[p].defending = 0;
				heroList[p].attacksLeft = heroList[p].maxAttacks;
				updateHeroBars(p,heroList[p]);
			}
			if (this.contains(assessGround))
			{
				removeChild(assessGround);
			}
			endTurnKeyLock = false;
		}
		private function nextEnemy(e:Event)
		{
			enemiesTurn++;
			if (enemiesTurn +1 <= enemyList.length)
			{
				enemyTurn(enemiesTurn);
			}
			else
			{
				stage.removeEventListener("next", nextEnemy);
				afterEndTurn();
			}
		}




		private function enemyTurn(index:int)
		{


			var i:int = index;
			if (enemyList[i].aim != null)
			{
				assessGround.assessAreaRoy(i);
				makeTweens(i);
				enemyList[i].movement(tileList, enemyLocation,mapArray,unitLocations);
			}
			else
			{
				enemyList[i].dispatchEvent(new Event("next", true));
			}


		}
		private function makeTweens(i:int):void
		{
			geo = new Sprite();
			geo.graphics.beginFill(0xFF0000,0.1);
			geo.graphics.drawRect(enemyList[i].aim.pt.x*tileSide,enemyList[i].aim.pt.y*tileSide,tileSide,tileSide);
			geo.graphics.endFill();
			myTween1 = new Tween(geo,"alpha",None.easeOut,4,0,1,true);
			myTween1.addEventListener(TweenEvent.MOTION_FINISH, endGraphic);
			myTween1.start();
			level.addChild(geo);

			leo = new Sprite();
			leo.graphics.beginFill(0x00FF00,0.1);
			leo.graphics.drawRect(enemyList[i].x,enemyList[i].y,tileSide,tileSide);
			leo.graphics.endFill();
			myTween2 = new Tween(leo,"alpha",None.easeOut,4,0,1,true);
			myTween2.addEventListener(TweenEvent.MOTION_FINISH, endGraphic);
			myTween2.start();
			level.addChild(leo);

			tweenList.push(myTween1,myTween2);
		}
		private function targetMenu(xLocation:int,yLocation:int)
		{
			var targetX = xLocation;
			var targetY = yLocation;

			if (enemyLocation[targetY][targetX] is Enemy)
			{
				trace(enemyList.indexOf(enemyLocation[targetY][targetX]));

			}
			else if (allyLocation[targetY][targetX])
			{

			}

		}

		private function getMenu():void
		{
			level.addChild(menu);
			menuOpen = true;
			trackMouse();
		}
		private function trackMouse():void
		{
			if (menuOpen == true)
			{
				trackMouseOn();
			}
			else if (menuOpen == false)
			{
				trackMouseOff();
			}
		}
		private function trackMouseOff():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, tryMouseMovement);
			stage.removeEventListener(MouseEvent.CLICK, mouseMoveAttack);
		}
		private function trackMouseOn():void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE, tryMouseMovement);
			stage.addEventListener(MouseEvent.CLICK, mouseMoveAttack);
			currentX = selectedBox.xCo;
			currentY = selectedBox.yCo;
		}
		private function tryMouseMovement(e:MouseEvent):void
		{
			mouseMovement();
		}
		private function mouseMovement():void
		{
			var cx:int = Math.floor(mouseX / 32);
			var cy:int = Math.floor(mouseY / 32);
			if (cx != currentX || cy != currentY)
			{
				if (Commons.checkB(cx,cy) == true)
				{
					if (heroAttacking == false)
					{
						currentX = cx;
						currentY = cy;
						moveSelectedBox(currentX,currentY);
					}
					else
					{
						currentX = cx;
						currentY = cy;
						moveAttackSelectedBox(currentX,currentY);
					}
				}
			}
		}
		private function moveCost(xCo,yCo):Number
		{
			//if you change these, you must change Nodes @ switch (mapValue)
			//also DijkPath
			var moveCost:int = 1;
			var mapValue:int = mapArray[yCo][xCo];
			switch (mapValue)
			{
				case 0 :

					break;

				case 1 :

					break;

				case 2 :
					moveCost +=  1;
					break;

				case 3 :

					break;

				case 4 :

					break;

				case 6 :
					moveCost +=  1;
					break;
			}
			var endingCost:int = heroList[playerSelected].cMove - moveCost;
			return endingCost;
		}
		private function removedShopWindow(e:Event):void
		{
			trace("removedShopWindow");
			e.target.removeEventListener(Event.REMOVED, removedShopWindow);
			shopOpen = false;
			infirmWinOpen = false;
			charterWinOpen = false;
			barracksWinOpen = false;
			if (shopWinOpen == true)
			{
				shopWinOpen = false;
			}
			pubWinOpen = false;

		}
		private function keyDownCheck(e:KeyboardEvent):void
		{

		}
		private function charRemoved(e:Event)
		{
			charScreen.removeEventListener(Event.REMOVED, charRemoved);
		}
		private function endGraphic(e:TweenEvent)
		{

			tweenList.splice(tweenList.indexOf(e.currentTarget), 1);

			e.currentTarget.removeEventListener(TweenEvent.MOTION_FINISH, endGraphic);

			if (this.contains(e.target.obj))
			{
				level.removeChild(e.target.obj);
			}
			if (tweenList.length == 0)
			{
				tweenList = new Array  ;
			}
		}
		public function moveSelectedBox(newX:int, newY:int):void
		{
			//Relocate selectedBox
			selectedBox.x = newX * tileSide;
			selectedBox.xCo = newX;
			selectedBox.pt.x = newX;
			selectedBox.y = newY * tileSide;
			selectedBox.yCo = newY;
			selectedBox.pt.y = newY;
			
			currentX = newX;
			currentY = newY;
			//Destroy old green
			removeGreenSqs();
			//create green Sqs to show path;
			if (heroAttacking == false && heroList[playerSelected].cMove > 0)
			{
				if (mapArray[newY][newX] != 1)
				{
					var movementPath:Path = new Path(heroList[playerSelected],newX,newY,mapArray,unitLocations);
					var myPath:Array = movementPath.getPath();
					movementPath.goExit();
					var pn:Object;
					for (var pathway:int=0; pathway < myPath.length; pathway++)
					{
						pn = myPath[pathway];
						greenSqs.push(makeSq(0x00FF00,0.4,pn.xCo,pn.yCo));
					}
				}
			}
			menu.xBox.text = newX.toString();
			menu.yBox.text = newY.toString();

			var percentHp:Number;
			if (enemyLocation[newY][newX] is Enemy)
			{
				percentHp = enemyLocation[newY][newX].eHp / enemyLocation[newY][newX].eMaxHp;
				battleFrame.eHpBar.scaleX = percentHp;
			}
		}
		public function moveAttackSelectedBox(newX:int, newY:int):void
		{
			var distance:int = Math.abs(blueSqs[1].x / 32 - newX) + Math.abs(blueSqs[1].y / 32 - newY);
			if (distance <= heroList[playerSelected].atkRange && heroList[playerSelected].attacksLeft > 0)
			{
				//Relocate selectedBox
				selectedBox.x = newX * tileSide;
				selectedBox.xCo = newX;
				selectedBox.pt.x = newX;
				selectedBox.y = newY * tileSide;
				selectedBox.yCo = newY;
				selectedBox.pt.y = newY;
				
				currentX = newX;
				currentY = newY;

				menu.xBox.text = newX.toString();
				menu.yBox.text = newY.toString();

				var percentHp:Number;
				if (enemyLocation[newY][newX] is Enemy)
				{
					percentHp = enemyLocation[newY][newX].eHp / enemyLocation[newY][newX].eMaxHp;
					battleFrame.eHpBar.scaleX = percentHp;
				}
			}
		}
		private function dropThings(q:int):void
		{
			switch (q)
			{
				case 1 :
					dropStone();
					break;

				case 2 :
					dropMountain();
					break;

				case 3 :
					dropFort();
					break;

				case 4 :
					dropDirt();
					break;

				case 6 :
					dropTrees();
					break;

			}
		}
		public function goExit():void
		{
			if (menuOpen == true)
			{
				removeMenu();
			}

			myTween1 = null;
			myTween2 = null;
			geo = null;
			leo = null;

			redSqs = null;
			greenSqs = null;
			blueSqs = null;
			atkSqs = null;

			selectedBox = null;
			menu = null;
			tileList = null;
			allyLocation = null;
			heroList = null;
			enemyLocation = null;
			enemyList = null;
			assessGround = null;

			battleFrame = null;
			charScreen = null;
			shopWindow = null;
			pubWindow = null;
			infirmWindow = null;
			barracksWindow = null;
			charterWindow = null;
			familyData = null;
			itemList = null;
			unitLocations = null;

			turnOffControls();
			stage.removeEventListener("hpBarUpdate",updateHpBar, false);

			if (level.contains(this))
			{
				level.removeChild(this);
			}
			level = null;



		}
	}

}