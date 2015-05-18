package  {
	
	import flash.display.MovieClip;
	
	
	public class L1 extends LClass {
		
		private var t1:String = "Hey, story time!"
		private var t2:String = "Let's get this started!"
		private var t3:String = "Let's get this finished!"
		
		public function L1() {
			dialArray = new Array;
			dialArray.push(t1,t2,t3);
			
			gameProgress=1;
			gameLevel = "Level1"
			
			mapArray = [  
			[0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0],
			[0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,6,6,6,0,0],
			[0,0,0,0,6,6,6,6,6,6,6,6,6,6,6,0,0,0,0,0],
			[0,0,0,0,0,6,6,6,6,6,6,6,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,6,6,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,0,0,0],
			[0,0,0,0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,0,0],
			[0,0,0,0,0,0,0,0,0,0,6,6,6,6,6,6,6,6,6,6]];
			// constructor code
		}
		override public function runEnemies():Array
		{
			var addList:Array = new Array;
			var enemy:Enemy
			
			enemy = new Bandit(3,5);
			addList.push(enemy)
			
			enemy = new Bandit(5,8);
			addList.push(enemy)
			
			enemy = new Bandit(2,10);
			addList.push(enemy)
			
			return addList;
		}
	}
	
}
