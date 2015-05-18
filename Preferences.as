package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Preferences extends MovieClip {
		
		private var prefOpen:Boolean;
		private var prefMenu:PrefMenu;
		private var heroesToAdd:Array
		private var itemList:Array
		private var familyData:FamilyData
		
		public function Preferences(HeroesToAdd:Array,ItemList:Array,_familyData:FamilyData) {
			heroesToAdd = HeroesToAdd
			itemList = ItemList
			familyData = _familyData
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, addedToStage)
		}
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage)
			addEventListener(MouseEvent.CLICK, openPrefMenu)
		}
		private function openPrefMenu(e:MouseEvent):void
		{
			if (prefOpen == false)
			{
			prefOpen = true;
			prefMenu = new PrefMenu(heroesToAdd,itemList,familyData);
			prefMenu.addEventListener(Event.REMOVED, prefRemoved)
			parent.addChild(prefMenu)
			prefMenu.x = 100
			prefMenu.y = 70
			}
		}
		private function prefRemoved(e:Event):void
		{
			prefOpen = false;
			prefMenu.removeEventListener(Event.REMOVED, prefRemoved)
			prefMenu = null;
		}
		public function doExit():void
		{
			heroesToAdd = null
			itemList = null
			familyData = null
		}
	}
	
}
