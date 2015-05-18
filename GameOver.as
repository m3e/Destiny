package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getDefinitionByName;
	
	
	public class GameOver extends MovieClip {
		
		private var heroesToAdd:Array;
		private var familyData:FamilyData;
		private var itemList:Array;
		
		public function GameOver(HeroesToAdd:Array,ItemList:Array,_familyData:FamilyData) {
			
			heroesToAdd = HeroesToAdd;
			familyData = _familyData;
			itemList = ItemList;
			
			Retry.addEventListener(MouseEvent.CLICK, retryGame)
			Retry.TextBox.text = "Retry?"
			Return.addEventListener(MouseEvent.CLICK, continueGame)
			Return.TextBox.text = "Return"
			// constructor code
		}
		private function retryGame(e:MouseEvent):void
		{
			var mainParent = this;
			while (!(mainParent is Main))
			{
				mainParent = mainParent.parent;
			}
			
			var Klasa = getDefinitionByName(getQualifiedClassName(this.parent));
			var game:* = new Klasa(false,itemList)
			game.heroesToAdd = heroesToAdd;
			game.loadFamilyValues(familyData);
			
			var thisParent:* = this.parent;
			thisParent.goExit();
			
			mainParent.loadChild(game);
			mainParent.stage.focus = game;
			
			doExit();
			
		}
		private function continueGame(e:MouseEvent):void
		{
			var mainParent = this;
			while (!(mainParent is Main))
			{
				mainParent = mainParent.parent;
			}
			
			var gameMap:GameMap = new GameMap(familyData,itemList)
			mainParent.loadChild(gameMap)
			
			var thisParent:* = this.parent;
			thisParent.goExit();
			
			doExit();
		}
		private function doExit():void
		{
			familyData = null;
			heroesToAdd = null;
			itemList = null;
			parent.removeChild(this);
		}
	}
	
}
