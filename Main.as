package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.Capabilities;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import sounds.SoundManager;





	public class Main extends MovieClip
	{

		private var myXML:XML;
		private var myLoader:URLLoader;
		private var itemList:Array;
		public var lastSave:String;
		public var currentChild:*;
		
		
		
		public function Main()
		{			
			
			itemList = new Array  ;
			myLoader = new URLLoader  ;
			myLoader.addEventListener(Event.COMPLETE,runWeapons);
			myLoader.load(new URLRequest("Armory.xml"));
			//myLoader.load(new URLRequest("https://dl.dropboxusercontent.com/s/k3u3fulp5cet4z7/Armory.xml"));
		}
		private function startGame():void
		{			
			
			
			SoundManager.bgfx("intro");
			var game:MainMenu;			
			game = new MainMenu(itemList);
			
			/*var game:Level1 = new Level1(false,itemList);
			var hero:Hero = new Hero(null,false)
			hero.xCo = 13
			hero.yCo = 6
			game.heroesToAdd.push(hero);
			hero = new Hero(null,false)
			hero.xCo = 14
			hero.yCo = 8
			hero.gotoAndStop(2)
			game.heroesToAdd.push(hero);*/
			
//			var game:Load = new Load("save1",null,itemList)

			loadChild(game)
			stage.stageFocusRect = false
			exit();
		}
		public function loadChild(level:*):void
		{
			currentChild = level;
			addChild(currentChild)
		}
		public function setSave(LastSave:String):void
		{
			lastSave = LastSave+"A"
		}
		private function exit():void
		{			
			currentChild = null;
			myXML = null;
			myLoader = null;
			itemList = null;
		}
		
		private function runWeapons(e:Event):void
		{
			myXML = new XML(e.target.data);
			var wepGroup:Array = new Array  ;
			var i:int = 0;
			while (i < myXML.WEAPON.length())
			{

				var atk:int = int(myXML.WEAPON[i].ATK);
				var def:int = int(myXML.WEAPON[i].DEF);
				var spd:int = int(myXML.WEAPON[i].SPD);
				var cost:int = int(myXML.WEAPON[i].COST);
				var wepType:String = String(myXML.WEAPON[i].NAME);
				var item_id = int(myXML.WEAPON[i].ITEM_ID);
				var slot = String(myXML.WEAPON[i].SLOT);
				var slotID = int(myXML.WEAPON[i].SLOT_ID);
				var range = int(myXML.WEAPON[i].RANGE);
				var wep:MovieClip;
				switch (wepType)
				{
					case "A" :
						wep = new Axe();
						wep.wepType = "Axe";
						break;
					case "B" :
						wep = new Bow();
						wep.wepType = "Bow";
						break;
					case "M" :
						wep = new Mace();
						wep.wepType = "Mace";
						break;
					case "S" :
						wep = new Sword();
						wep.wepType = "Sword";
						break;
					case "SP" :
						wep = new Spear();
						wep.wepType = "Spear";
						break;
					case "Helm" :
						wep = new Head();
						wep.wepType = "Head";
						break;
					case "Chest" :
						wep = new Chest();
						wep.wepType = "Chest";
						break;
					case "Boots" :
						wep = new Feet();
						wep.wepType = "Feet";
						break;
					case "Gloves" :
						wep = new Hands();
						wep.wepType = "Hands";
						break;					
				}


				wep.atk = atk;
				wep.def = def;
				wep.spd = spd;
				wep.cost = cost;
				wep.item_id = item_id;
				wep.slot = slot;
				wep.slotID = slotID
				wep.range = range;
				wepGroup.push(wep);
				wep.gotoAndStop(wepGroup.length);				
				;
				if ((i+1 == myXML.WEAPON.length()) || i+1 < myXML.WEAPON.length() && myXML.WEAPON[i].NAME != myXML.WEAPON[i+1].NAME)
				{
					itemList.push(wepGroup);
					wepGroup = new Array  ;
				}
				i++;

			}
			startGame();
		}

	}

}