package  {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	public class PrepareScreen extends MovieClip {

		private var familyData:FamilyData
		private var itemList:Array
		public function PrepareScreen(FamData:FamilyData,ItemList:Array) {
			familyData = FamData;
			itemList = ItemList;
			NextBtn.addEventListener(MouseEvent.CLICK, nextRound);
		}
		private function nextRound(e:Event):void
		{
			dispatchEvent(new Event("nextLevel", true));			
		}
		public function goExit():void
		{
			familyData = null;
			itemList = null;
			NextBtn.removeEventListener(MouseEvent.CLICK, nextRound);
			parent.removeChild(this);
		}
	}
	
}
