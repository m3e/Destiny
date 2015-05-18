package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;
	
	
	public class NewBaby extends MovieClip {
		
		private var myBaby:Object;
		public function NewBaby(baby:Object) {
			myBaby = baby;
			babyStats.text = "Max HP: " + baby.cMaxHp + "\n" +
				"Attack: " + baby.cAtk + "\n" +
				"Mana: " + baby.cMana + "\n" +
				"Spell Dmg: " + baby.cSplDmg + "\n" +
				"Defense: " + baby.cDef;
			xBtn.addEventListener(MouseEvent.CLICK, doExit);
			checkBtn.addEventListener(MouseEvent.CLICK, accept);
			// constructor code
		}
		private function doExit(e:MouseEvent):void
		{
			exit();			
		}
		private function accept(e:MouseEvent):void
		{			
			dispatchEvent(new Event("accept",true));			
			exit();
		}
		private function exit():void
		{
			myBaby = null;
			checkBtn.removeEventListener(MouseEvent.CLICK, accept);
			xBtn.removeEventListener(MouseEvent.CLICK, doExit);
			parent.removeChild(this);
		}
	}
	
}
