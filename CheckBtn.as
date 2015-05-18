package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.events.Event;
	
	import sounds.SoundManager;
	
	public class CheckBtn extends MovieClip {
		
		var clickButton:Sound
		public function CheckBtn() {
			addEventListener(MouseEvent.CLICK, playSound)
			addEventListener(Event.REMOVED, doExit)
		}
		private function playSound(e:MouseEvent):void
		{
			SoundManager.sfx("clickbutton");
		}
		private function doExit(e:Event):void
		{
			clickButton = null;
			removeEventListener(MouseEvent.CLICK, playSound)
			removeEventListener(Event.REMOVED, doExit)
		}
	}
	
}
