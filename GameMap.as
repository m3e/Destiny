package 
{

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import sounds.SoundManager;


	public class GameMap extends Sprite
	{

		private var familyData:FamilyData;
		private var itemList:Array;
		private var levelList:Array;
		private var mapPreview:MapPreview;



		public function GameMap(FamData:FamilyData,ItemList:Array)
		{

			SoundManager.bgfx("gameMap");

			mapPreview = new MapPreview();
			mapPreview.mouseChildren = false;
			mapPreview.mouseEnabled = false;
			levelList = new Array  ;
			levelList.push(l1,l2,l3,l4,l5,l6,l7,l8);
			itemList = ItemList;
			familyData = FamData;
			mapPreview.scaleX = .5;
			mapPreview.scaleY = .5;
			mapPreview.x = 150;
			mapPreview.y = 106;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			for (var i:int=0; i < levelList.length; i++)
			{
				levelList[i].addEventListener(MouseEvent.MOUSE_OVER, displayLevel);
				levelList[i].addEventListener(MouseEvent.MOUSE_OUT, removeLevel);
				levelList[i].addEventListener(MouseEvent.CLICK, onClick);
			}
			// constructor code
		}
		private function addedToStage(e:Event):void
		{

			var mainParent:* = this.parent;
			var save:Save = new Save(mainParent.lastSave.substring(0,5),familyData.toBeSaved());
		}
		private function displayLevel(e:MouseEvent):void
		{
			var level:* = e.currentTarget;
			addChild(mapPreview);
			mapPreview.viewMap(level.mapArray);
		}

		private function removeLevel(e:MouseEvent):void
		{
			if (contains(mapPreview))
			{
				removeChild(mapPreview);
			}
		}
		private function onClick(e:MouseEvent):void
		{
			if (familyData.gameProgress >= levelList.indexOf(e.currentTarget))
			{
				var teamManager:TeamManager = new TeamManager(familyData,itemList,e.currentTarget.gameLevel);
				var mainParent:* = parent;
				while (!(mainParent is Main))
				{
					mainParent = mainParent.parent;
				}
				mainParent.loadChild(teamManager);
				doExit();
			}
			else
			{
				trace("not here yet");
			}
		}
		private function doExit():void
		{
			for (var i:int=0; i < levelList.length; i++)
			{
				levelList[i].removeEventListener(MouseEvent.MOUSE_OVER, displayLevel);
				levelList[i].removeEventListener(MouseEvent.MOUSE_OUT, removeLevel);
				levelList[i].removeEventListener(MouseEvent.CLICK, onClick);
			}
			familyData = null;
			itemList = null;
			levelList = null;
			mapPreview = null;
			parent.removeChild(this);
		}
	}

}