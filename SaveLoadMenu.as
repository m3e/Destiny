package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.net.SharedObject;
	import flash.utils.getQualifiedClassName;
	import flash.geom.Point;


	public class SaveLoadMenu extends MovieClip
	{
		public var reference:Object;
		private var saveOptions:Array;
		private var goalParent:Object;
		private var level:Object;

		public function SaveLoadMenu(Level:Object)
		{
			// constructor code
			level = Level;						
			addEventListener(Event.ADDED_TO_STAGE, parentCheck);
			saveOptions = new Array  ;
			saveOptions.push(save1,save2,save3);
		}
		private function parentCheck(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, parentCheck);
			goalParent = this.parent;
			while (!(goalParent is Main))
			{
				goalParent = goalParent.parent;
			}
			
		}
		public function saveLoadStart():void
		{
			save1.saveBarText.text = "Save One"
			save2.saveBarText.text = "Save Two"
			save3.saveBarText.text = "Save Three"
			save1.saveBarText.addEventListener(MouseEvent.CLICK, saveOrLoad);
			save2.saveBarText.addEventListener(MouseEvent.CLICK, saveOrLoad);
			save3.saveBarText.addEventListener(MouseEvent.CLICK, saveOrLoad);
			xButton.addEventListener(MouseEvent.CLICK, doExit);			
		}
		private function saveOrLoad(e:MouseEvent):void
		{
			if (reference == null)
			{
				e.target.text = "[S]ave  /  [L]oad";
				reference = e.target.parent;
				dispatchEvent(new Event("saveOrLoad", true));
			}			
		}
		public function saveConfirm():void
		{
			reference.saveBarText.text = "Save?  [Y] [N]?";
		}
		public function loadConfirm():void
		{
			reference.saveBarText.text = "Load?  [Y] [N]?";
		}
		public function saveGame(cLevel:String, heroSave:Array, enemySave:Array, MapArray:Array,PlayerSelected:int,FamilySave:Array):void
		{			
			
			//var lastSaved:SharedObject = SharedObject.getLocal("initiate");
			//lastSaved.data.lastSave = reference.name;
			//lastSaved.flush();
			//var saveGame:Save = new Save(reference.name,MapArray,cLevel,heroSave,enemySave,PlayerSelected,FamilySave)
			
			/*var sharedObject:SharedObject = SharedObject.getLocal(reference.name);						
			sharedObject.data.mapArray = newTheMap(MapArray);
			sharedObject.data.gameLevel = clevel;
			sharedObject.data.heroArray = newTheMap(heroSave);			
			sharedObject.data.enemyArray = newTheMap(enemySave);
			sharedObject.data.playerSelected = PlayerSelected;						
			sharedObject.data.familySave = newTheMap(FamilySave);
			sharedObject.flush();
			sharedObject = SharedObject.getLocal("Destiny")
			trace("Saving");*/
			
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
		
		public function loadGame(ItemList:Array):void
		{
			trace("disabled @ saveloadmenu.as")
			/*var loadGame:Load = new Load(reference,level,ItemList);
			goExit();
			goalParent.addChild(loadGame);
			level = null;			*/
		}
		private function doExit(e:MouseEvent):void
		{
			goExit();
		}
		public function goExit():void
		{
			save1.saveBarText.removeEventListener(MouseEvent.CLICK, saveOrLoad);
			save2.saveBarText.removeEventListener(MouseEvent.CLICK, saveOrLoad);
			save3.saveBarText.removeEventListener(MouseEvent.CLICK, saveOrLoad);			
			
			
			reference = null;
			if (parent != null && parent.contains(this))
			{
			parent.removeChild(this);
			}

		}

	}

}