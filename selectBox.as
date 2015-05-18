package  {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	
	public class selectBox extends MovieClip {
		
		public var yCo:int;
		public var xCo:int;
		public var pt:Point;
		public function selectBox(xCoord:int,yCoord:int) {
			mouseEnabled = false;
			mouseChildren = false;
			Backdrop.visible = false;
			y=yCoord * 32;
			x=xCoord * 32;
			pt = new Point(xCoord,yCoord);
			yCo = yCoord;
			xCo = xCoord;
			// constructor code
		}
	}
	
}
