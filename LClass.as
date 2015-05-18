package  {
	
	import flash.display.Sprite;
	
	
	public class LClass extends Sprite {
		
		public var mapArray:Array
		public var gameLevel:String;
		public var gameProgress:int;
		public var coinGain:int;
		public var dialArray:Array;
		
		public function LClass() {
			// constructor code
		}
		public function runEnemies():Array
		{
			var addList:Array = new Array;
			var enemy:Enemy
			
			enemy = new Enemy(12,6);
			addList.push(enemy)
			
			return addList;
		}
		public function runAllies(famData:FamilyData):Array
		{
			var addList:Array = new Array;
			
			var char:Hero = famData.heroMembers[0]
			char.xCo = 2;
			char.yCo = 8;
			addList.push(char);
			
			return addList;
		}
	}
	
}
