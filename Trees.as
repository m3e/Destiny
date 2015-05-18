package 
{

	import flash.display.MovieClip;


	public class Trees extends MovieClip
	{


		public var yCo:int;
		public var xCo:int;
		public var backgroundTile:Object;
		public var occupied:Boolean;
		public var indexOfChar:int;
		public function Trees(xCoords:int, yCoords:int)
		{
			alpha = 0.7;
			xCo = xCoords;
			yCo = yCoords;
			occupied = false;
			gotoAndStop(Math.ceil(Math.random()*6));
		}

	}
}