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

		private var familyArray:Array;
		private var goalParent:*;
		private var itemList:Array;
		private var familyData:FamilyData;
		private var lastSave:String

		public function Load(NewReference:String,ItemList:Array)
		{
			//How to Use:
			//Load class
			//Add as child
			lastSave = NewReference;
			itemList = ItemList;

			sharedObject = SharedObject.getLocal(NewReference);
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
			if (familyArray == null)
			{
				trace("No Game");
				exit();
			}
			else
			{

				
					loadFamilyValues(familyArray);
					var gameMap:GameMap = new GameMap(familyData,itemList);
					sharedObject = null;
					goalParent.setSave(lastSave)
					goalParent.loadChild(gameMap)
					goalParent.stage.focus = gameMap;
					exit();
				
			}

		}
		private function loadFamilyValues(_FamData:Array):void
		{
			var hero:Spec;
			familyData = new FamilyData(true,itemList);
			var famData = _FamData;
			familyData.coin = famData[0];
			familyData.loadInventory(famData[1]);
			familyData.XP = (famData[2]);
			for (var i:int=0; i<famData[3].length; i++)
			{
				hero = new Spec(familyData,true);
				hero.uniqueID = famData[3][i][0];
				equipHero(hero,famData[3][i][1]);
				hero.monstersKilled = famData[3][i][2];
				hero.gotoAndStop(famData[3][i][3]);
				hero.experience = famData[3][i][4];
			}
			familyData.gameProgress = famData[4];
			trace(famData[5]);
			familyData.firstTime = famData[5]
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
		private function exit():void
		{
			itemList = null;

			goalParent = null;

			familyData = null;

			sharedObject = null;

			familyArray = null;

			parent.removeChild(this);
		}

	}

}