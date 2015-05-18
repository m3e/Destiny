package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	
	import sounds.SoundManager;
	public class XButton extends MovieClip {
		
		private var clickButton:Sound
		//loadIcon used in MainMenu
		public var loadIcon:MovieClip;
		
		public function XButton() {
			addEventListener(MouseEvent.CLICK, playSound)
			addEventListener(Event.REMOVED,doExit)
			// constructor code
		}
		private function playSound(e:Event)
		{
			SoundManager.sfx("clickbutton");
		}
		private function doExit(e:Event)
		{
			clickButton = null;
			loadIcon = null;
			removeEventListener(MouseEvent.CLICK, playSound)
			removeEventListener(Event.REMOVED,doExit)
		}
	}
	
}
