package  {
	
	import flash.display.MovieClip;
	
	
	public class L4 extends LClass {
		
		public function L4() {
			gameProgress=4
			gameLevel = "Level4"
			mapArray = [  
			[4,4,0,0,0,1,0,0,0,0,0,4,0,6,6,6,6,6,6,6],
			[0,4,0,0,0,1,1,0,0,0,0,0,4,0,0,6,6,6,6,6],
			[0,4,0,0,0,4,3,0,0,0,0,0,0,4,0,0,0,6,6,6],
			[0,4,0,0,4,4,1,0,0,0,0,0,0,4,0,0,0,0,0,6],
			[4,4,4,4,4,3,1,1,1,1,1,1,1,4,0,0,0,0,0,6],
			[0,4,4,4,4,2,2,2,2,2,2,2,2,4,0,0,0,0,0,0],
			[0,4,4,4,4,2,2,2,2,2,2,2,2,4,4,4,4,4,4,4],
			[0,4,4,4,4,3,1,1,1,1,1,1,0,0,4,4,0,0,0,0],
			[4,4,0,0,4,4,1,0,0,0,0,0,0,0,4,0,0,0,0,0],
			[0,4,0,0,0,4,3,1,0,0,0,0,4,4,0,0,0,0,0,6],
			[0,4,0,0,0,1,1,0,0,0,0,4,0,0,0,0,0,0,6,6],
			[0,4,0,0,0,1,0,0,0,4,4,0,6,0,6,6,6,6,6,6]];			
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
