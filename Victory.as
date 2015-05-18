package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	
	public class Victory extends MovieClip {
		
		public function Victory(FamData:*,gameLevel:Level) {
			// constructor code
			var coinGain:int = gameLevel.coinGain;
			
			CoinGain.text = coinGain.toString();
			XPGain.text = "--";
			
			FamData.coin += coinGain
			//FamData.XP += xpGain
			if (FamData.gameProgress < gameLevel.gameProgress)
			{
			FamData.gameProgress = gameLevel.gameProgress;
			}
			FamData = null;
			acceptButton.addEventListener(MouseEvent.CLICK, doAccept);
		}
		private function doAccept(e:MouseEvent):void
		{
			parent.removeChild(this);
		}
	}
	
}
