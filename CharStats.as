package 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.ui.Mouse;


	public class CharStats extends MovieClip
	{
		private var familyData:Object;
		private var itemSelected:MovieClip;
		private var hero:Hero;
		private var equipList:Array;
		private var displayList:Array;

		public function CharStats(FamilyData:Object)
		{
			// constructor code
			BackWall.visible = false;

			displayList = new Array  ;
			equipList = [Head,Chest,Boots,RHand,LHand,RPad,LPad];
			
			WeaponInfoBox.mouseEnabled = false;
			WeaponInfoBox.mouseChildren = false;
			WeaponInfoBox.visible = false;
			
			WeaponBoxSelect.mouseEnabled = false;
			WeaponBoxSelect.mouseChildren = false;
			WeaponBoxSelect.visible = false;
			
			familyData = FamilyData;
			
			hero = familyData.heroMembers[0];
			loadHero(hero);
			hero.x=0
			hero.y=0;
			CharBox.addChild(hero);

			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
			Head.addEventListener(MouseEvent.CLICK, doEquip, false, 0, true);
			Chest.addEventListener(MouseEvent.CLICK, doEquip, false, 0, true);
			Boots.addEventListener(MouseEvent.CLICK, doEquip, false, 0, true);
			LHand.addEventListener(MouseEvent.CLICK, doEquip, false, 0, true);
			RHand.addEventListener(MouseEvent.CLICK, doEquip, false, 0, true);
			LPad.addEventListener(MouseEvent.CLICK, doEquip, false, 0, true);
			RPad.addEventListener(MouseEvent.CLICK, doEquip, false, 0, true);
			InventoryBox.addEventListener(MouseEvent.CLICK, putInInv, false, 0, true);

			StrBox.addEventListener(MouseEvent.CLICK, addStr, false, 0, true);
			AgiBox.addEventListener(MouseEvent.CLICK, addAgi, false, 0, true);
			IntBox.addEventListener(MouseEvent.CLICK, addInt, false, 0, true);

		}
		private function addedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, displayInv);
			refreshInv();
		}
		private function doEquip(e:Event):void
		{

			equip(e.target);
		}
		private function equip(itemSlot:Object):void
		{
			var a:int = 0;
			//if selecting equipped item
			if (itemSelected == null)
			{
				if (hero.equipArray[equipList.indexOf(itemSlot)] != null)
				{
					selectEquipped(hero.equipArray[equipList.indexOf(itemSlot)],itemSlot);
				}
			}
			else
			{
				//if selecting equipped item twice
				if (hero.equipArray[equipList.indexOf(itemSlot)] == itemSelected)
				{
					itemSelected = null;
					WeaponBoxSelect.visible = false;;
				}
				else if (equipList.indexOf(itemSlot) == itemSelected.slotID)
				{
					//if equipping
					a++;
					//if there is already an item
					if (hero.equipArray[equipList.indexOf(itemSlot)] != null)
					{
						RHand.removeChild(hero.equipArray[equipList.indexOf(itemSlot)]);
						familyData.inventory[familyData.inventory.indexOf(itemSelected)] = hero.equipArray[equipList.indexOf(itemSlot)];
						hero.equipArray[3].mouseEnabled = true;
						hero.equipArray[3].mouseChildren = true;
						hero.equipArray[3].addEventListener(MouseEvent.CLICK, selectBox, false, 0, true);
						hero.equipArray[3].x = itemSelected.x;
						hero.equipArray[3].y = itemSelected.y;
						InventoryBox.addChild(hero.equipArray[equipList.indexOf(itemSlot)]);
						hero.unequip(hero.equipArray[equipList.indexOf(itemSlot)],equipList.indexOf(itemSlot));
					}

					//regardless if there is an item already there
					itemSelected.removeEventListener(MouseEvent.CLICK, selectBox);
					InventoryBox.removeChild(itemSelected);
					RHand.addChild(itemSelected);
					itemSelected.x = 0;
					itemSelected.y = 0;
					itemSelected.mouseEnabled = false;
					itemSelected.mouseChildren = false;
					WeaponBoxSelect.visible = false;
					hero.equip(itemSelected,equipList.indexOf(itemSlot));
					//if new equipment is in INV
					if (familyData.inventory.indexOf(itemSelected) != -1)
					{
						familyData.inventory.splice(familyData.inventory.indexOf(itemSelected),1);
					}
					itemSelected = null;
					loadHero(hero);


				}

			}
			if (a == 1)
			{
				refreshInv();
			}

		}

		private function selectEquipped(Item:MovieClip,xAndY:Object):void
		{
			itemSelected = Item;
			WeaponBoxSelect.visible = true;
			WeaponBoxSelect.x = xAndY.x + 16;
			WeaponBoxSelect.y = xAndY.y + 16;
		}
		private function selectBox(e:Event):void
		{

			var item:* = e.target;

			//if there is no item selected
			if (itemSelected == null)
			{

				itemSelected = item;
				WeaponBoxSelect.visible = true;

			}
			else
			{
				//if swapping equipped item for unequipped
				if (hero.equipArray.indexOf(itemSelected) != -1)
				{
					itemSelected = item;
					equip(equipList[itemSelected.slotID]);
				}
				else if (e.target == itemSelected)
				{
					//if item clicked on twice
					//if you are unclicking an item
					WeaponBoxSelect.visible = false;;
					itemSelected = null;
				}
				else
				{
					//if you are selecting another item
					itemSelected = item;
				}
			}
			WeaponBoxSelect.x = InventoryBox.x + e.target.x + 16;
			WeaponBoxSelect.y = InventoryBox.y + e.target.y + 16;

		}
		private function displayHeroes():void
		{
			for (var i:int = 0; i < familyData.heroMembers.length; i++)
			{

			}
		}

		public function refreshInv():void
		{
			removeDisplay();
			displayInv();
		}

		private function displayInv():void
		{
			var b:int;
			var c:int;
			var o:int = -1;
			displayList = new Array  ;
			for (var i:int=0; i<familyData.inventory.length; i++)
			{
				if (c == 6)
				{
					c = 0;
					b++;
					o = -1;
				}
				o++;
				familyData.inventory[i].y = (b * 38);
				familyData.inventory[i].x = o * 32;
				InventoryBox.addChild(familyData.inventory[i]);
				familyData.inventory[i].addEventListener(MouseEvent.CLICK, selectBox, false, 0, true);
				familyData.inventory[i].addEventListener(MouseEvent.MOUSE_OVER, displayStats, false, 0, true);
				familyData.inventory[i].addEventListener(MouseEvent.MOUSE_OUT, undisplayStats, false, 0, true);
				displayList.push(familyData.inventory[i]);
				c++;
			}

			for (var k:int=0; k < hero.equipArray.length; k++)
			{
				if (hero.equipArray[k] != null)
				{
					equipList[k].addChild(hero.equipArray[k]);
					hero.equipArray[k].x = 0;
					hero.equipArray[k].y = 0;
					hero.equipArray[k].mouseEnabled = false;
					hero.equipArray[k].mouseChildren = false;
					hero.equipArray[k].addEventListener(MouseEvent.MOUSE_OVER, displayStats, false, 0, true);
					hero.equipArray[k].addEventListener(MouseEvent.MOUSE_OUT, undisplayStats, false, 0, true);
				}
			}
			if (!(this.contains(WeaponBoxSelect)))
			{
				trace(this.numChildren);
				addChildAt(WeaponBoxSelect,this.numChildren);
				WeaponBoxSelect.visible = false;
			}
			if (!(this.contains(WeaponInfoBox)))
			{
				addChild(WeaponInfoBox);
				WeaponInfoBox.visible = false;
			}

		}
		private function putInInv(e:Event):void
		{

			//if item is equipped
			if (itemSelected != null && hero.equipArray.indexOf(itemSelected) != -1)
			{
				WeaponBoxSelect.visible = false;;
				hero.unequip(itemSelected,hero.equipArray.indexOf(itemSelected));

				equipList[itemSelected.slotID].removeChild(itemSelected);

				itemSelected.mouseEnabled = true;
				itemSelected.mouseChildren = true;
				itemSelected.addEventListener(MouseEvent.CLICK, selectBox, false, 0, true);

				InventoryBox.addChild(itemSelected);

				var newY:int = Math.floor(familyData.inventory.length / 6);
				var newX:int = familyData.inventory.length % 6;
				itemSelected.x = (newX * 32);
				itemSelected.y = (newY * 32);

				familyData.pushToInventory(itemSelected);
				itemSelected = null;
				loadHero(hero);
				refreshInv();
			}
		}
		private function displayStats(e:Event):void
		{
			WeaponInfoBox.AtkBox.text = e.target.atk;
			WeaponInfoBox.DefBox.text = e.target.def;
			WeaponInfoBox.SpdBox.text = e.target.spd;
			WeaponInfoBox.CostBox.text = e.target.cost;
			WeaponInfoBox.TypeBox.text = e.target.wepType;
			WeaponInfoBox.x = 0;
			WeaponInfoBox.y = 0;
			WeaponInfoBox.visible = true;
		}
		private function undisplayStats(e:Event):void
		{
			WeaponInfoBox.visible = false;
		}		
		public function loadHero(Hero:Object):void
		{
			Level.text = Hero.cLevel.toString();
			Hp.text = Hero.cHp.toString() + " / " + Hero.cMaxHp.toString();
			Atk.text = Hero.cAtk.toString();
			Def.text = Hero.cDef.toString();
			StrBox.text = Hero.cStr.toString();
			AgiBox.text = Hero.cAgi.toString();
			IntBox.text = Hero.cInt.toString();
			Xp.text = Hero.experience;

		}
		private function addInt(e:MouseEvent):void
		{
			hero.cInt++;
			hero.refreshStats();
			loadHero(hero);
		}
		private function addAgi(e:MouseEvent):void
		{
			hero.cAgi++;
			hero.refreshStats();
			loadHero(hero);
		}
		private function addStr(e:MouseEvent):void
		{
			hero.cStr++;
			hero.refreshStats();
			loadHero(hero);
		}

		public function removeDisplay():void
		{

			removeChild(WeaponInfoBox);
			removeChild(WeaponBoxSelect);
			for (var k:int=0; k<hero.equipArray.length; k++)
			{
				if (hero.equipArray[k] != null)
				{
					if (equipList[k].contains(hero.equipArray[k]))
					{
						equipList[k].removeChild(hero.equipArray[k]);
						equipList[k].removeEventListener(MouseEvent.MOUSE_OVER, displayStats);
						equipList[k].removeEventListener(MouseEvent.MOUSE_OUT, undisplayStats);
					}
				}
			}
			for (var i:int=0; i< familyData.inventory.length; i++)
			{
				familyData.inventory[i].removeEventListener(MouseEvent.CLICK, selectBox);
				familyData.inventory[i].removeEventListener(MouseEvent.MOUSE_OVER, displayStats);
				familyData.inventory[i].removeEventListener(MouseEvent.MOUSE_OUT, undisplayStats);
				if (InventoryBox.contains(familyData.inventory[i]))
				{
					InventoryBox.removeChild(familyData.inventory[i]);
				}
			}
			itemSelected = null;
			displayList = null;

		}
		public function goExit():void
		{
			removeDisplay();

			StrBox.removeEventListener(MouseEvent.CLICK, addStr);
			AgiBox.removeEventListener(MouseEvent.CLICK, addAgi);
			IntBox.removeEventListener(MouseEvent.CLICK, addInt);

			Head.removeEventListener(MouseEvent.CLICK, equip);
			Chest.removeEventListener(MouseEvent.CLICK, equip);
			Boots.removeEventListener(MouseEvent.CLICK, equip);
			LHand.removeEventListener(MouseEvent.CLICK, equip);
			RHand.removeEventListener(MouseEvent.CLICK, equip);
			LPad.removeEventListener(MouseEvent.CLICK, equip);
			RPad.removeEventListener(MouseEvent.CLICK, equip);

			

			InventoryBox.removeEventListener(MouseEvent.CLICK, putInInv);


			displayList = null;
			itemSelected = null;
			equipList = null;
			familyData = null;
			CharBox.removeChild(hero);
			hero = null;

			parent.removeChild(this);
		}
	}

}