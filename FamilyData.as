package 
{

	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;

	public class FamilyData extends MovieClip
	{


		private var itemList:Array;

		public var coin:int;
		public var XP:int;
		public var inventory:Array;
		public var heroMembers:Array;
		public var gameProgress:int
		public var firstTime:Boolean;
		public function FamilyData(isALoad:Boolean,ItemList:Array)
		{
			firstTime = true;
			heroMembers = new Array  ;
			itemList = ItemList;
			inventory = new Array  ;
			if (isALoad == true)
			{

			}
			if (isALoad == false)
			{

			}
			// constructor code
		}

		public function addMember(hero:Hero):void
		{
			//Gives the hero a unique member ID
			//Adds unit to heroMembers array which is used to Save
			var uniID:int = Math.random() * 999999;
			var a:int = 0;
			while (a == 0)
			{
				a = 1;
				for (var i:int=0; i<heroMembers.length; i++)
				{
					if (uniID == heroMembers[i].uniqueID)
					{
						a = 0;
					}
				}
				if (a == 0)
				{
					uniID = Math.random() * 999999;
				}
			}

			heroMembers.push(hero);
			trace("Hero member added.. Count:" + heroMembers.length);
		}

		public function toBeSaved():Array
		{
			var familyArray:Array = new Array  ;
			//Save the inventory list
			var inventory_id = new Array;
			for (var i:int=0; i<inventory.length; i++)
			{
				inventory_id.push(inventory[i].item_id);
			}
			//Save the heroes in memberList
			var heroSaves:Array = new Array  ;
			var hero:Hero;
			for (var o:int=0; o < heroMembers.length; o++)
			{
				hero = heroMembers[o];
				heroSaves.push(hero.saveToFamily());
			}
			familyArray.push(coin,inventory_id,XP,heroSaves,gameProgress,firstTime);
			return familyArray;
		}
		
		public function pushToInventory(Item:Object):void
		{
			inventory.push(Item);
		}
		public function makeNewItem(Item:Object):Object
		{
			var Klasa = getDefinitionByName(Item.wepType);
			var item:* = new Klasa  ;
			item.atk = Item.atk;
			item.spd = Item.def;
			item.def = Item.def;
			item.cost = Item.cost;
			item.wepType = Item.wepType;
			item.item_id = Item.item_id;
			item.slot = Item.slot;
			item.slotID = Item.slotID;
			item.range = Item.range;
			item.gotoAndStop(Item.currentFrame);
			return item
		}
		public function addToInventory(Item:Object):void
		{
			//also at load
			
			inventory.push(makeNewItem(Item));
		}
		public function loadInventory(invId:Array):void
		{
			var q:int;
			var w:int;
			var item:int;
			for (var i:int=0; i<invId.length; i++)
			{
				item = invId[i]				
				q = Math.floor(item / 1000)-1;
				w = item % 1000;								
				addToInventory(itemList[q][w]);
			}
		}
		public function goExit():void
		{
			trace("FAM DATA EXIT");
			itemList = null;
			inventory = null;
			heroMembers = null;
		}
	}

}