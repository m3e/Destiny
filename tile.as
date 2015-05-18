package 
{

	import flash.display.MovieClip;


	public class tile extends MovieClip
	{
		public var yCo:int;
		public var xCo:int;
		public var occupied:Boolean;
		public var indexOfChar:int;
		
		public function tile(xArray:int,yArray:int)
		{
			xCo = xArray;
			yCo = yArray;
			occupied = false;
			// constructor code
		}
		/*public function setCoords():void
		{
			trace (yCoord, xCoord);
		}*/

	}

}