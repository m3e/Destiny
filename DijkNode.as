package 
{

	import flash.display.MovieClip;


	public class DijkNode extends MovieClip
	{
		public var dist:int;
		public var xCo:int;
		public var yCo:int;
		public var myParent:Object;
		
		public function DijkNode(distance:int,X:int,Y:int)
		{
			dist = distance;
			xCo = X;
			yCo = Y;
		}
		

	}

}