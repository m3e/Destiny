package  {
	
	import flash.display.MovieClip;
	
	
	public class L8 extends LClass {
		
		public function L8() {
			gameProgress=8
			gameLevel = "Level8"
			mapArray = [  
			[2,2,2,0,2,2,2,2,2,2,2,0,2,2,0,2,2,2,2,0],
			[0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
			[2,2,2,2,0,0,0,0,6,6,0,0,0,0,0,0,2,2,2,2],
			[2,2,2,2,0,0,0,6,0,0,6,0,0,0,0,0,0,2,2,2],
			[2,2,2,0,0,0,0,6,0,0,6,0,0,0,0,0,0,2,2,2],
			[4,4,4,0,0,0,0,0,6,6,0,0,0,0,0,0,0,2,2,2],
			[2,2,2,0,0,0,0,6,0,0,6,0,0,0,0,0,0,2,2,2],
			[2,2,2,0,0,0,0,6,0,0,6,0,0,0,0,0,2,2,2,2],
			[0,2,2,2,0,0,0,0,6,6,0,0,0,0,0,2,2,2,2,0],
			[2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2],
			[2,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]];			

			// constructor code
		}
		override public function runEnemies():Array
		{
			var addList:Array = new Array;
			var enemy:Enemy
			
			enemy = new Enemy(10,6);
			addList.push(enemy)
			
			return addList;
		}
	}
	
}
