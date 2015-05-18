package  {
	
	import flash.display.MovieClip;
	
	
	public class L2 extends LClass {
		
		public function L2() {
			gameProgress=2
			gameLevel = "Level2"
			mapArray = [  
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,2,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,2,2,0,0,2,0,2,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,2,2,2,0,0,0,0,2,0,0,0,0,0,0,0,0],
			[0,0,0,0,2,0,2,1,2,2,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,2,0,0,2,4,0,2,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,1,0,0,0,0,2,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,1,0,0,0,2,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,1,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];			
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
