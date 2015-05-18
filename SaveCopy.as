package  {
	
	import flash.display.MovieClip;
	import flash.net.SharedObject;
		
	public class Save extends MovieClip {

		public function Save(SaveSlot:String,MapArray:Array,CurrentLevel:String,HeroSave:Array,EnemySave:Array,PlayerSelected:int,FamilySave:Array) {
			
			var sharedObject:SharedObject = SharedObject.getLocal(SaveSlot);						
			sharedObject.data.mapArray = newTheMap(MapArray);
			sharedObject.data.gameLevel = CurrentLevel;
			sharedObject.data.heroArray = newTheMap(HeroSave);			
			sharedObject.data.enemyArray = newTheMap(EnemySave);
			sharedObject.data.playerSelected = PlayerSelected;						
			sharedObject.data.familySave = newTheMap(FamilySave);
			sharedObject.flush();
			sharedObject = SharedObject.getLocal("Destiny")
			trace("Saving");
		}
		private function newTheMap(array:Array):Array
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
