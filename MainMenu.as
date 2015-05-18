package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	import sounds.SoundManager;
	
	public class MainMenu extends MovieClip
	{

		private var itemList:Array;
		private var sharedObject:SharedObject;

		public function MainMenu(ItemList:Array)
		{
			itemList = ItemList;
			
			Load1.saveReference = "save1";
			Load1.slotName = "Load 1"
			Load1.slot = 0;
			checkLoad(Load1);

			Load2.saveReference = "save2";
			Load2.slotName = "Load 2"
			Load2.slot = 55;
			checkLoad(Load2);

			Load3.saveReference = "save3";
			Load3.slotName = "Load 3"
			Load3.slot = 110;
			checkLoad(Load3);
			// constructor code
		}
		private function checkLoad(loadIcon:MovieClip):void
		{
			sharedObject = SharedObject.getLocal(loadIcon.saveReference);

			if (sharedObject.data.familySave == null)
			{
				loadIcon.LoadText.text = "New Game";
				loadIcon.addEventListener(MouseEvent.CLICK, newGame, false, 0, true);
			}
			else
			{

				loadIcon.LoadText.text = loadIcon.slotName;
				var xBtn:XButton = new XButton();
				addChild(xBtn);
				xBtn.loadIcon = loadIcon;
				xBtn.loadIcon.addEventListener(MouseEvent.CLICK, loadGame,false,0,true);
				xBtn.x = 450;
				xBtn.y = 282 + loadIcon.slot;
				xBtn.addEventListener(MouseEvent.CLICK, deleteSave,false,0,true);
			}
			sharedObject = null;
		}
		private function newGame(e:MouseEvent):void
		{
			SoundManager.sfx("clickbutton");
			var nGame:StartNewGame = new StartNewGame(itemList,e.currentTarget.saveReference);
			parent.addChild(nGame);
			parent.stage.focus = nGame;
			exit();
		}
		private function deleteSave(e:MouseEvent):void
		{

			var xBtn = e.currentTarget;
			xBtn.loadIcon.removeEventListener(MouseEvent.CLICK, loadGame);
			sharedObject = SharedObject.getLocal(xBtn.loadIcon.saveReference);
			sharedObject.clear();
			sharedObject = null;
			checkLoad(xBtn.loadIcon);
			xBtn.removeEventListener(MouseEvent.CLICK, deleteSave);
			removeChild(xBtn);
		}
		private function loadGame(e:MouseEvent):void
		{
			SoundManager.sfx("clickbutton");
			var loadGame = new Load(e.currentTarget.saveReference,itemList);
			parent.addChild(loadGame);
			exit();
		}

		public function exit():void
		{
			itemList = null;
			sharedObject = null;
			parent.removeChild(this);

		}

	}

}