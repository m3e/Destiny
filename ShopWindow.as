package 
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class ShopWindow extends MovieClip
	{
		
		private var typeIndex:Array;
		public var displayList:Array;		
		private var familyData:Object;
		private var itemSelected:Object;
		private var itemList:Array;
		private var equipWindow:CharStats;
		

		public function ShopWindow(FamilyData:Object,ItemList:Array,EquipWindow:CharStats)
		{
			equipWindow = EquipWindow;
			
			itemList = ItemList;
			familyData = FamilyData;			
			removeChild(WeaponInfoBox);
			WeaponInfoBox.mouseEnabled = false;
			WeaponInfoBox.mouseChildren = false;
			
			ShopBox.WeaponBoxSelect.mouseChildren = false;
			ShopBox.WeaponBoxSelect.mouseEnabled = false;
			ShopBox.WeaponBoxSelect.visible = false;
			
			BuyButton.visible = false;
			BuyButton.addEventListener(MouseEvent.CLICK, buyItem);			
			
			typeIndex = new Array  ;
			displayList = new Array  ;
			
			typeIndex.push(AxeType,BowType,MaceType,SwordType,SpearType,HeadType,FeetType,ChestType,HandsType);
			
			AxeType.addEventListener(MouseEvent.CLICK, switchDisplay);
			SwordType.addEventListener(MouseEvent.CLICK, switchDisplay);
			SpearType.addEventListener(MouseEvent.CLICK, switchDisplay);
			MaceType.addEventListener(MouseEvent.CLICK, switchDisplay);
			BowType.addEventListener(MouseEvent.CLICK, switchDisplay);
			FeetType.addEventListener(MouseEvent.CLICK, switchDisplay);
			HandsType.addEventListener(MouseEvent.CLICK, switchDisplay);
			ChestType.addEventListener(MouseEvent.CLICK, switchDisplay);
			HeadType.addEventListener(MouseEvent.CLICK, switchDisplay);
			
			addEventListener(Event.ADDED_TO_STAGE, updateGold);
			// constructor code
		}
		private function updateGold(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, updateGold);
			CurrentGold.text = familyData.coin.toString();
		}
		private function buyItem(e:Event):void
		{

			if (familyData.coin >= itemSelected.cost)
			{
				familyData.coin -=  itemSelected.cost;
				CurrentGold.text = familyData.coin.toString();				
				familyData.addToInventory(itemSelected);
				equipWindow.refreshInv();
			}
			else
			{
				trace("not enough gold");
			}
		}
		private function switchDisplay(e:Event):void
		{
			undisplayWeapons();
			displayWeapons(typeIndex.indexOf(e.target));
		}
		
		public function undisplayWeapons():void
		{			
			ShopBox.WeaponBoxSelect.visible = false;
			BuyButton.visible = false;
			while (displayList.length > 0)
			{
				ShopBox.removeChild(displayList[0]);
				displayList[0].removeEventListener(MouseEvent.MOUSE_OVER, displayStats);
				displayList[0].removeEventListener(MouseEvent.MOUSE_OUT, undisplayStats);
				displayList[0].removeEventListener(MouseEvent.CLICK, selectBox);				
				displayList.shift();
			}
		}
		private function selectBox(e:Event):void
		{

			itemSelected = e.target;
			ShopBox.WeaponBoxSelect.visible = true;			
			ShopBox.WeaponBoxSelect.x = e.target.x + 16;
			ShopBox.WeaponBoxSelect.y = e.target.y + 16;
			BuyButton.visible = true;			

		}
		private function displayWeapons(k:int):void
		{			
			for (var i:int=0; i < itemList[k].length; i++)
			{				
				ShopBox.addChild(itemList[k][i]);				
				displayList.push(itemList[k][i]);
				itemList[k][i].x = i*33 + 3
				itemList[k][i].y = 4
				
				itemList[k][i].addEventListener(MouseEvent.MOUSE_OVER, displayStats);
				itemList[k][i].addEventListener(MouseEvent.MOUSE_OUT, undisplayStats);
				itemList[k][i].addEventListener(MouseEvent.CLICK, selectBox);

			}			
		}
		private function displayStats(e:Event):void
		{
			addChild(WeaponInfoBox);
			WeaponInfoBox.AtkBox.text = e.target.atk;
			WeaponInfoBox.DefBox.text = e.target.def;
			WeaponInfoBox.SpdBox.text = e.target.spd;
			WeaponInfoBox.CostBox.text = e.target.cost;
			WeaponInfoBox.TypeBox.text = e.target.wepType;
			
			
		}
		private function undisplayStats(e:Event):void
		{
			removeChild(WeaponInfoBox);
			
		}
		private function doExit(e:MouseEvent):void
		{
			//undisplayWeapons();
			//removeChild(this);
		}
		public function goExit():void
		{
			undisplayWeapons();
			equipWindow = null;
						
			BuyButton.removeEventListener(MouseEvent.CLICK, buyItem);
			AxeType.removeEventListener(MouseEvent.CLICK, switchDisplay);
			SwordType.removeEventListener(MouseEvent.CLICK, switchDisplay);
			SpearType.removeEventListener(MouseEvent.CLICK, switchDisplay);
			MaceType.removeEventListener(MouseEvent.CLICK, switchDisplay);
			BowType.removeEventListener(MouseEvent.CLICK, switchDisplay);
			FeetType.removeEventListener(MouseEvent.CLICK, switchDisplay);
			HandsType.removeEventListener(MouseEvent.CLICK, switchDisplay);
			ChestType.removeEventListener(MouseEvent.CLICK, switchDisplay);
			HeadType.removeEventListener(MouseEvent.CLICK, switchDisplay);
			//xBtn.removeEventListener(MouseEvent.CLICK, doExit);
			
			typeIndex = null;			
			familyData = null;
			itemSelected = null;
			itemList = null;
			displayList = null;
						
			parent.removeChild(this);
		}

	}

}