package common {
	import flash.display.Sprite;
	
	public class Commons extends Sprite{

		public static var mapWidth:int = 20;
		public static var mapHeight:int = 15;
		public static var tileSide:int = 32;
		
		public function Commons() {
			// constructor code
		}
		public static function dist(firstX:int,firstY:int,secondX:int,secondY:int):int
		{
			var dist:int = Math.abs(firstX - secondX) + Math.abs(firstY - secondY)
			return dist
		}
		public static function checkB(xCo:int,yCo:int):Boolean
		{
			var inBounds:Boolean;
			
			if (xCo >= 0 && xCo < mapWidth && yCo >= 0 && yCo < mapHeight)
			{
				inBounds = true;
			}

			return inBounds;
		}
		public static function newTheMap(array:Array):Array
		{
			var newArray:Array = new Array  ;
			for (var i:int = 0; i < array.length; i++)
			{
				var content:* = array[i];
				if (content is Array)
				{
					newArray[i] = newTheMap(content);
				}
				else
				{
					newArray[i] = content;
				}
			}
			return newArray
		}

	}
	
}
