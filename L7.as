package  {
	
	import flash.display.MovieClip;
	
	
	public class L7 extends LClass {
		
		public function L7() {
			gameProgress=7
			gameLevel = "Level7"
			mapArray = [  
			[6,6,6,0,6,6,6,6,6,6,6,0,6,6,0,6,6,6,6,0],
			[0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6],
			[6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6],
			[6,6,6,6,0,0,0,6,6,6,6,6,0,0,0,0,6,6,6,6],
			[6,6,6,6,0,0,0,0,0,0,0,6,0,0,0,0,0,6,6,6],
			[6,6,6,0,0,0,0,0,0,0,6,0,0,0,0,0,0,6,6,6],
			[4,4,4,0,0,0,0,0,0,6,0,0,0,0,0,0,0,6,6,6],
			[6,6,6,0,0,0,0,0,6,0,0,0,0,0,0,0,0,6,6,6],
			[6,6,6,0,0,0,0,6,0,0,0,0,0,0,0,0,6,6,6,6],
			[0,6,6,6,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,0],
			[6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6],
			[6,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6]];			

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
