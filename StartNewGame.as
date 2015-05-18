package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class StartNewGame extends MovieClip
	{
		
		private var itemList:Array;
		private var spLeft:int;
		private var cStr:int;
		private var cAgi:int;
		private var cInt:int;
		private var saveSlot:String

		public function StartNewGame(ItemList:Array,SaveSlot:String)
		{
			saveSlot = SaveSlot
			cNameBox.restrict = "a-z A-Z";
			cNameBox.maxChars = 12;
			itemList = new Array  ;
			itemList = ItemList;
			spLeft = 0;
			spLeftBox.text = spLeft.toString();
			cStr = 5;
			cAgi = 5;
			cInt = 5;
			CheckButton.addEventListener(MouseEvent.CLICK, accept);
			sPlus.addEventListener(MouseEvent.CLICK, sUp);
			sMinus.addEventListener(MouseEvent.CLICK, sDown);
			aPlus.addEventListener(MouseEvent.CLICK, aUp);
			aMinus.addEventListener(MouseEvent.CLICK, aDown);
			iPlus.addEventListener(MouseEvent.CLICK, iUp);
			iMinus.addEventListener(MouseEvent.CLICK, iDown);
			xBtn.addEventListener(MouseEvent.CLICK, doExit);
		}
		private function sUp(e:Event):void
		{
			if (spLeft > 0)
			{
				spLeft--;
				cStr++;
				cStrBox.text = cStr.toString();
				spLeftBox.text = spLeft.toString();
			}
		}
		private function sDown(e:Event):void
		{
			if (cStr > 5)
			{
				spLeft++;
				cStr--;
				cStrBox.text = cStr.toString();
				spLeftBox.text = spLeft.toString();
			}
		}
		private function aUp(e:Event):void
		{
			if (spLeft > 0)
			{
				spLeft--;
				cAgi++;
				cAgiBox.text = cAgi.toString();
				spLeftBox.text = spLeft.toString();
			}
		}
		private function aDown(e:Event):void
		{
			if (cAgi > 5)
			{
				spLeft++;
				cAgi--;
				cAgiBox.text = cAgi.toString();
				spLeftBox.text = spLeft.toString();
			}
		}
		private function iUp(e:Event):void
		{
			if (spLeft > 0)
			{
				spLeft--;
				cInt++;
				cIntBox.text = cInt.toString();
				spLeftBox.text = spLeft.toString();
			}
		}
		private function iDown(e:Event):void
		{
			if (cInt > 5)
			{
				spLeft++;
				cInt--;
				cIntBox.text = cInt.toString();
				spLeftBox.text = spLeft.toString();
			}
		}
		private function accept(e:MouseEvent):void
		{
			if (cNameBox.length >= 3 && spLeft == 0)
			{
				
				var familyData:FamilyData = new FamilyData(false, itemList);
				
				var character:Spec = new Spec(familyData, true)
				character.cStr = cStr
				character.cAgi = cAgi
				character.cInt = cInt
				character.refreshStats();
				
				CheckButton.removeEventListener(MouseEvent.CLICK, accept);

				var gameMap:GameMap = new GameMap(familyData,itemList)
				//var teamManager:TeamManager = new TeamManager(familyData,itemList)
				//parent.addChild(teamManager);
				var mainParent:* = this.parent;
				mainParent.setSave(saveSlot);
				mainParent.loadChild(gameMap);
				exit();
			}
			else
			{
				if (spLeft > 0)
				{
					trace("sp points left");
				}
				if (cNameBox.length < 3)
				{
					trace("3 char min");
				}
			}

			
		}
		private function doExit(e:MouseEvent):void
		{
			var game:MainMenu;
			game = new MainMenu(itemList);
			parent.addChild(game);
			exit();
		}
		private function exit():void
		{
			
			sPlus.removeEventListener(MouseEvent.CLICK, sUp);
			sMinus.removeEventListener(MouseEvent.CLICK, sDown);
			aPlus.removeEventListener(MouseEvent.CLICK, aUp);
			aMinus.removeEventListener(MouseEvent.CLICK, aDown);
			iPlus.removeEventListener(MouseEvent.CLICK, iUp);
			iMinus.removeEventListener(MouseEvent.CLICK, iDown);
			xBtn.removeEventListener(MouseEvent.CLICK, doExit);
			itemList = null;			
			parent.removeChild(this);
		}


	}

}