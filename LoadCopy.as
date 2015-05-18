package 
{
	import flash.display.MovieClip;
	import flash.utils.getQualifiedClassName;
	import flash.net.SharedObject;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	import flash.system.*;

	public class Load extends MovieClip
	{
		private var sharedObject:SharedObject;
		public var gLevel:String;
		private var heroSaves:Array;
		private var enemySaves:Array;
		private var mapArray:Array;
		private var familyArray:Array;
		public var currentMap:*;
		private var goalParent:*;
		private var currentLevel:Object;
		private var itemList:Array;
		private var familyData:FamilyData;

		public function Load(NewReference:*,Level:Object,ItemList:Array)
		{
			//How to Use:
			//Load class
			//Add as child

			itemList = ItemList;

			if (NewReference is String)
			{
				sharedObject = SharedObject.getLocal(NewReference);
			}
			else
			{
				sharedObject = SharedObject.getLocal(NewReference.name);

			}

			currentLevel = Level;

			gLevel = sharedObject.data.gameLevel;
			heroSaves = sharedObject.data.heroArray;
			enemySaves = sharedObject.data.enemyArray;
			mapArray = sharedObject.data.mapArray;
			familyArray = sharedObject.data.familySave;
			addEventListener(Event.ADDED_TO_STAGE, parentCheck);
			// constructor code
		}
		private function parentCheck(e:Event):void
		{
			stage.stageFocusRect = false;
			removeEventListener(Event.ADDED_TO_STAGE, parentCheck);

			//Set goalParent as Main
			goalParent = this.parent;
			while (!(goalParent is Main))
			{
				goalParent = goalParent.parent;
			}
			//If there's nothing in the save information, there's no game.
			if (gLevel == null)
			{
				trace("No Game");
				exit();
			}
			else
			{

				//if this load was created pointing to another class, close that class
				if (currentLevel != null)
				{
					//close the class
					currentLevel.goExit();
					currentLevel = null;
				}
				
				if (gLevel == "TeamManager")
				{

				}
				else
				{
					//Get the object the game was last left on from sharedObject.data.gameLevel
					var Klasa = getDefinitionByName(gLevel);
					//Create a new instance of the class referenced from gLevel
					currentMap = new Klasa(true,itemList);
					//Change the map to what was saved
					changeMapProperties();
					//Add child of the level saved (just makes the map since isLoad is on)
					goalParent.addChild(currentMap);
					//Associate familyData to the level;
					loadFamilyValues(familyArray);
					//Initialize the controls
					currentMap.initGameControls();
					//Add the enemies from the save;
					loadEnemy();
					//Add the heroes from the save
					loadHero();
					//Turn on keyboard eventlistener and add battleframe
					currentMap.loadUp();
					//Change playerselected;
					currentMap.gameControls.playerSelected = sharedObject.data.playerSelected;
					goalParent.stage.focus = currentMap;
					sharedObject = null;
					exit();
				}
			}

		}
		private function loadFamilyValues(_FamData:Array):void
		{
			var hero:Hero;
			familyData = new FamilyData(true,itemList);
			var famData = _FamData;
			familyData.coin = famData[0];
			familyData.loadInventory(famData[1]);
			familyData.XP = (famData[2]);
			familyData.gameProgress = famData[4];
			for (var i:int=0; i<famData[3].length; i++)
			{
				hero = new Hero(familyData,true);
				hero.uniqueID = famData[3][i][0];
				equipHero(hero,famData[3][i][1]);
				hero.monstersKilled = famData[3][i][2];
				hero.gotoAndStop(famData[3][i][3]);
				hero.experience = famData[3][i][4];
			}
			currentMap.loadFamilyValues(familyData);
		}
		private function changeMapProperties():void
		{

			currentMap.mapArray = sharedObject.data.mapArray;

		}
		private function newTheMap(array:Array):Array
		{
			var newArray:Array = new Array  ;
			for (var i:int = 0; i < array.length; i++)
			{
				var content:* = array[i];
				if (content is Array)
				{
					newArray[i] = newTheMap(content);
				}
				else
				{
					newArray[i] = content;
				}
			}
			return newArray;
		}

		private function loadHero():void
		{
			var character:Hero;
			for (var i:int=0; i<heroSaves.length; i++)
			{

				if (heroSaves[i][0] == "H")
				{

					character = new Hero(familyData,false);
					character.xCo = heroSaves[i][1][0];
					character.yCo = heroSaves[i][1][1];
					character.cMove = heroSaves[i][1][2];
					character.cMoveMax = heroSaves[i][1][3];
					character.cLevel = heroSaves[i][1][4];
					character.cHp = heroSaves[i][1][5];
					character.cMaxHp = heroSaves[i][1][6];
					character.cAtk = heroSaves[i][1][7];
					character.cDef = heroSaves[i][1][8];
					character.stone = heroSaves[i][1][9];
					character.monstersKilled = heroSaves[i][1][10];
					character.gotoAndStop(heroSaves[i][1][11]);
					character.cStr = heroSaves[i][1][12];
					character.cAgi = heroSaves[i][1][13];
					character.cInt = heroSaves[i][1][14];
					character.experience = heroSaves[i][1][15];
					currentMap.heroesToAdd.push(character);





				}
			}
			currentMap.addHeroes();

		}
		private function equipHero(hero:Hero,famData:Array):void
		{
			var q:int;
			var w:int;
			var item:int;
			for (var i:int=0; i<hero.equipArray.length; i++)
			{
				var a:int = 0;
				var invId:Array = new Array  ;
				invId = famData;
				item = invId[i];
				
				if (item <= 0)
				{

				}
				else
				{
					q = Math.floor(item / 1000) - 1;
					w = item % 1000;
					a++;
				}
				var equip:*;
				if (a == 1)
				{
					//also at familydata
					
					
					var Item = itemList[q][w];
					equip = familyData.makeNewItem(Item)
					hero.equip(equip,i);
				}
				else
				{
					equip = null;
					hero.equipArray[i] = equip;
				}

			}

		}
		private function loadEnemy():void
		{
			for (var i:int=0; i<enemySaves.length; i++)
			{
				if (enemySaves[i][0] == "E")
				{
					var enemy:Enemy = new Enemy(enemySaves[i][1],enemySaves[i][2]);
					enemy.eHp = enemySaves[i][3];
					enemy.eDef = enemySaves[i][4];
					enemy.eMagDef = enemySaves[i][5];
					enemy.eAtk = enemySaves[i][6];
					enemy.eReturnDmg = enemySaves[i][7];
					enemy.eVision = enemySaves[i][8];
					currentMap.addEnemy(enemy);
				}
			}
		}

		private function exit():void
		{
			itemList = null;
			currentLevel = null;

			currentMap = null;
			goalParent = null;

			familyData = null;

			sharedObject = null;
			heroSaves = null;
			enemySaves = null;
			mapArray = null;
			familyArray = null;

			parent.removeChild(this);
		}

	}

}