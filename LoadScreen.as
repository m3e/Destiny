package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.events.Event;

	public class LoadScreen extends MovieClip
	{
		public var reference:String;
		private var a:int;

		public function LoadScreen()
		{
			a = 0;
			xBtn.addEventListener(MouseEvent.CLICK, doExit);
			load1.addEventListener(MouseEvent.CLICK, loadGame);
			load2.addEventListener(MouseEvent.CLICK, loadGame);
			load3.addEventListener(MouseEvent.CLICK, loadGame);
			// constructor code
		}
		private function loadGame(e:MouseEvent):void
		{
			trace(e.target.name);
			switch (e.target.name)
			{
				case "load1" :
					reference = "save1";										
					break;

				case "load2" :
					reference = "save2";					
					break;

				case "load3" :
					reference = "save3";					
					break;
			}
			a++;			
			exit();

		}
		private function doExit(e:MouseEvent):void
		{
			this.visible = false;
		}
		public function exit():void
		{						
			if (a == 1)
			{
				dispatchEvent(new Event("loading",true));
			}
			reference = null;
			xBtn.removeEventListener(MouseEvent.CLICK, exit);
			load1.removeEventListener(MouseEvent.CLICK, loadGame);
			load2.removeEventListener(MouseEvent.CLICK, loadGame);
			load3.removeEventListener(MouseEvent.CLICK, loadGame);			
			parent.removeChild(this);
			
		}
	}

}