package  {
	
	import flash.display.MovieClip;
	import flash.net.SharedObject;
		
	public class Save extends MovieClip {

		public function Save(SaveSlot:String,FamilySave:Array) 
		{
			var sharedObject:SharedObject = SharedObject.getLocal(SaveSlot);									
			sharedObject.data.familySave = newTheMap(FamilySave);
			sharedObject.flush();
			sharedObject = null;
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
