package  {
	
	import flash.display.MovieClip;
	
	
	public class L3 extends LClass {
		
		public function L3() {
			gameProgress=3
			gameLevel = "Level3"
			mapArray = [  
			[6,6,6,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[6,6,0,0,0,1,2,2,0,0,0,0,0,0,0,0,0,0,0,0],
			[6,6,0,0,0,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0],
			[6,0,0,4,4,4,3,1,2,0,0,0,0,0,0,0,0,0,0,0],
			[6,0,0,4,0,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0],
			[6,0,0,4,0,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[6,0,0,4,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[6,0,0,4,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0],
			[6,6,0,4,0,0,0,1,4,0,0,1,0,0,0,0,0,0,0,0],
			[6,0,0,4,4,4,4,4,4,4,0,0,1,0,0,0,0,0,0,0],
			[6,0,0,0,0,0,0,1,4,0,0,0,0,0,0,0,0,0,0,0],
			[6,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0]];			
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
