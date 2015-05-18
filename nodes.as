package 
{

	import flash.display.MovieClip;


	public class nodes extends MovieClip
	{

		public var h:int;
		public var g:int;
		public var f:int;
		public var aimX:int;
		public var aimY:int;
		public var xCo:int;
		public var yCo:int;
		public var myParent:Object;
		public var mapValue:int;
		public var moveCost:int;
		private var extraG:int;
		private var moveValue:int;


		public function nodes(mama:Object, xCoords:int, yCoords:int, targetX:int, targetY:int,mapTileValue:int)
		{
			moveValue = 10;
			mapValue = mapTileValue;
			xCo = xCoords;
			yCo = yCoords;
			myParent = mama;
			aimX = targetX;
			aimY = targetY;
			
			g = mama.g + moveValue;
			
			h = (Math.abs(xCo-aimX) + Math.abs(yCo - aimY)) * 20;
			strategize();
			//trace("f:"+f+"g:"+g+"h:"+h+ "X,Y:"+xCo, yCo);
			//trace(g, h * 10, f);
			// constructor code
		}
		public function strategize():void
		{
			switch (mapValue)
			{
					//if you change these, you must change gameControls @ function moveCost
					//also change DijkPath
					//g gets divided by double move value
				case 0 :
					g +=  moveValue;
					break;

				case 1 :

					break;

				case 2 :
					//double cost
					g +=  (moveValue * 3);
					break;

				case 3 :
					g += moveValue
					break;

				case 4 :
					g += moveValue

					break;
				
				case 6 :
					g +=  (moveValue * 3);										
					break;
			}
			
			f = g + h;			
			moveCost = g / (moveValue * 2)
			moveCost--;
		}

	}

}