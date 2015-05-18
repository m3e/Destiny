package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class DialogueBox extends MovieClip
	{

		private var dialArray:Array;
		public function DialogueBox(dialogue:Array)
		{
			dialArray = dialogue;
			addEventListener(Event.ADDED_TO_STAGE, listen);
			// constructor code
		}
		private function listen(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, listen);
			
			addEventListener(MouseEvent.CLICK, nextText);
			DialText.text = dialArray[0];
		}
		private function nextText(e:MouseEvent):void
		{
			if (dialArray.length > 0)
			{
				dialArray.splice(0,1);
				if (dialArray.length > 0)
				{
					DialText.text = dialArray[0];
				}
				else
				{
					removeEventListener(MouseEvent.CLICK, nextText);
					parent.removeChild(this);
				}
			}
		}
	}
}