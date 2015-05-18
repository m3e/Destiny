package  {
	
	import flash.display.MovieClip;
	
	
	public class Mountain extends MovieClip {
		
		
		public var yCo:int;
		public var xCo:int;
		public var occupied:Boolean;
		public var indexOfChar:int;
		public function Mountain(xCoords:int, yCoords:int) {
			xCo = xCoords;
			yCo = yCoords;
			occupied = false;
			gotoAndStop(Math.ceil(Math.random()*4));
			// constructor code
		}
	}
	
}
