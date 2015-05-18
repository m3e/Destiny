package  {
	
	import flash.display.MovieClip;
	
	
	public class Dirt extends MovieClip {
		
		public var yCo:int;
		public var xCo:int;
		public var occupied:Boolean;
		public var indexOfChar:int;
		
		public function Dirt(xArray:int, yArray:int) {
			xCo = xArray;
			yCo = yArray;
			occupied = false;
			gotoAndStop(Math.ceil(Math.random()*3));
			// constructor code
		}
	}
	
}
