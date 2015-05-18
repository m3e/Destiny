package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName
	import flash.utils.getQualifiedClassName

	public class PrefMenu extends MovieClip
	{
		private var _restart:Boolean;
		private var _return:Boolean;
		private var _returnMM:Boolean;
		private var heroesToAdd:Array;
		private var itemList:Array;
		private var familyData:FamilyData;
		public function PrefMenu(HeroesToAdd:Array,ItemList:Array,_familyData:FamilyData)
		{
			heroesToAdd = HeroesToAdd;
			itemList = ItemList;
			familyData = _familyData
			;
			ConfirmBox.visible = false;
			RestartMap.addEventListener(MouseEvent.CLICK, restartMap);
			RestartMap.TextBox.text = "Restart Battle";
			ReturnToMap.addEventListener(MouseEvent.CLICK, returnToMap);
			ReturnToMap.TextBox.text = "Return to Map";
			ReturnToMainMenu.addEventListener(MouseEvent.CLICK, returnToMainMenu);
			ReturnToMainMenu.TextBox.text = "Return to Main Menu";
			xBtn.addEventListener(MouseEvent.CLICK, mouseDoExit);
			ConfirmBox.yesBtn.addEventListener(MouseEvent.CLICK, confirmYes);
			ConfirmBox.noBtn.addEventListener(MouseEvent.CLICK, confirmNo);
		}
		// constructor code;
		private function confirmNo(e:MouseEvent):void
		{
			ConfirmBox.visible = false;
			_restart = false;
			_return = false;
			_returnMM = false;
		}
		private function confirmYes(e:MouseEvent):void
		{
			if (_restart == true)
			{
				var mainParent = this;
				while (!(mainParent is Main))
				{
					mainParent = mainParent.parent;
				}

				var Klasa = getDefinitionByName(getQualifiedClassName(mainParent.currentChild));
				var game:* = new Klasa(false,itemList);
				game.heroesToAdd = heroesToAdd;
				game.loadFamilyValues(familyData);

				mainParent.currentChild.goExit()

				mainParent.loadChild(game);
				mainParent.stage.focus = game;

				doExit();
			}
			else if (_return == true)
			{

			}
			else if (_returnMM == true)
			{

			}
			doExit();
		}
		private function restartMap(e:MouseEvent):void
		{
			ConfirmBox.ExplainText.text = "Restart this battle?  This level's progress will not be saved.?";
			ConfirmBox.visible = true;
			_restart = true;
		}
		private function returnToMap(e:MouseEvent):void
		{
			ConfirmBox.ExplainText.text = "Return to game map?  This level's progress will not be saved.";
			ConfirmBox.visible = true;
			_return = true;
		}
		private function returnToMainMenu(e:MouseEvent):void
		{
			ConfirmBox.ExplainText.text = "Return to main menu?  This level's progress will not be saved.";
			ConfirmBox.visible = true;
			_returnMM = true;
		}
		private function mouseDoExit(e:MouseEvent):void
		{
			doExit();
		}
		private function doExit():void
		{
			heroesToAdd = null;
			itemList = null;
			familyData = null;
			parent.removeChild(this);
		}
	}

}