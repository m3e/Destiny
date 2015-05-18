package  {
	
	import flash.display.MovieClip;
	
	
	public class BattleFrame extends MovieClip {
		
		private var hpBars:Array
		private var hpTexts:Array
		private var apTexts:Array;
		public function BattleFrame() {
			y = 382;
			hpBars = new Array;
			hpBars.push(hpBarGfx1,hpBarGfx2,hpBarGfx3,hpBarGfx4)
			hpTexts = new Array;
			hpTexts.push(hpBar1,hpBar2,hpBar3,hpBar4)
			apTexts = new Array;
			apTexts.push(apText1,apText2,apText3,apText4)
			// constructor code
		}
		public function setHpBar(i:int,hero:Object):void
		{			
			var percent:Number = hero.cHp / hero.cMaxHp;			
			if (percent > 1)
			{
				percent = 1
			}
			hpBars[i].scaleX = percent			
			
			hpTexts[i].text = (hero.cHp+" / "+hero.cMaxHp);
			hero = null;
		}		
		public function setApText(i:int,hero:Object):void
		{
			apTexts[i].text = hero.cMove
			hero = null;
		}
	}
	
}
