package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	
	public class test extends MovieClip {
		
		
		public function test(xLocation:int, yLocation:int) {
			x = xLocation;
			y = yLocation;
			
			//trace(xLocation/32+"x",yLocation/32+"test tile");
			// constructor code
		}
		public function removeSelf():void{
			this.parent.removeChild(this);
		}
	}
	
}
