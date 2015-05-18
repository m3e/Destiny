package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	
	public class TeamManager extends MovieClip {
		
		private var familyData:FamilyData;
		private var itemList:Array;
		private var shopWindow:ShopWindow;	
		private var equipWindow:CharStats;
		private var prepareScreen:PrepareScreen;
		private var nextLevel:String;
		
		public function TeamManager(_FamilyData:FamilyData,ItemList:Array,NextLevel:String) {
			nextLevel = NextLevel;
			BackWall.visible = false;
			familyData = _FamilyData
			itemList = ItemList;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			// constructor code
		}
		private function addedToStage(e:Event):void
		{						
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);			
			trace(parent);
			equipWindow = new CharStats(familyData);
			equipWindow.x = 213;			
			addChild(equipWindow);
			
			shopWindow = new ShopWindow(familyData,itemList,equipWindow);			
			addChild(shopWindow);			
			
			prepareScreen = new PrepareScreen(familyData,itemList);
			prepareScreen.x = 426;
			addChild(prepareScreen);
			addEventListener("nextLevel",goNextLevel);
			
		}
		private function refreshInv(e:Event):void
		{
			equipWindow.refreshInv();			
		}
		private function goNextLevel(e:Event):void
		{
			
			removeEventListener("nextLevel",goNextLevel);
			
			shopWindow.goExit();
			equipWindow.goExit();
			prepareScreen.goExit();
			
			shopWindow = null;
			equipWindow = null;
			prepareScreen = null;
						
			var gameName:* = getDefinitionByName(nextLevel);
			var game:* = new gameName(familyData,false,itemList);
			
			var mainParent:* = parent;
			while (!(mainParent is Main))
			{
				mainParent = mainParent.parent;
			}
			mainParent.loadChild(game);
			
			parent.stage.focus = game
			
			itemList = null;
			familyData = null;
			parent.removeChild(this);
			
			
		}
	}
	
}
