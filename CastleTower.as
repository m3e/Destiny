package  {
	
	import flash.display.MovieClip;
	
	
	public class CastleTower extends MovieClip {
		
		public var yCo:int;
		public var xCo:int;
		public var occupied:Boolean;
		public var indexOfChar:int;
		
		public function CastleTower(xArray:int, yArray:int) {
			xCo = xArray;
			yCo = yArray;
			occupied = false;
			// constructor code
		}
	}
	
}
