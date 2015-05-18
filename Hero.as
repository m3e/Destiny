package 
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Hero extends MovieClip
	{
		private var movePathCounter:int;		
		public var movePath:Array;
		public var movementTimer:Timer = new Timer(100);
		private var unitLocations:Array;
		
		public var stone:int;		
		
		public var cMove:int;
		public var cMoveMax:int;
		public var cLevel:int;
		public var cHp:int;
		public var cMaxHp:int;		
		public var cAtk:int;		
		public var cDef:int;
		
		public var cStr:int
		public var cAgi:int
		public var cInt:int
		
		public var bonusHp:int;
		
		public var xCo:int;
		public var yCo:int;										
				
		public var monstersKilled:int;
		private var tileList:Array;
		private var allyLocation:Array;
		private var allySight:Array;
		public var experience:int;
				
		public var baseHp:int;
		public var baseAtk:int;
		public var baseDef:int;
		
		public var bonusAtk:int;
		public var bonusDef:int;
		
		public var equipArray:Array;
		public var rHand:Object;
		public var lHand:Object;
		public var rPad:Object;
		public var lPad:Object;
		public var head:Object;
		public var chest:Object;
		public var boots:Object;
		
		public var atkRange:int;
		
		public var uniqueID:int;
		
		public var defending:int;
		public var attacksLeft:int;
		public var maxAttacks:int;

		public function Hero(famData:FamilyData,addToFamily:Boolean)
		{
			stop();
			maxAttacks = 1;
			attacksLeft = maxAttacks;;
			atkRange = 1;
			equipArray = new Array;
			equipArray = [head,chest,boots,rHand,lHand,rPad,lPad]
			
			allySight = new Array  ;
			allyLocation = new Array  ;
			tileList = new Array  ;
			
			baseHp = 20
			cMaxHp = baseHp;
			cHp = cMaxHp
			cMoveMax = 6;
			cMove = cMoveMax;
			
			baseAtk = 0
			baseDef = 0
			
			stone = 3;
			
			cStr = 5
			cAgi = 5
			cInt = 5						
			
			cAtk = baseAtk;
			cDef = baseDef;
			monstersKilled = 0;			
			addEventListener(Event.ADDED_TO_STAGE, added);			
			if (addToFamily == true)
			{
			famData.addMember(this)
			}
			// constructor code
		}
		private function added(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			x = xCo * 32;
			y = yCo * 32;
			refreshStats();
		}
		public function unequip(Item:Object,slot):void
		{
			bonusAtk -= Item.atk
			bonusDef -=	Item.def
			refreshStats();
			atkRange = 1;
			equipArray[slot] = null;;
		}
		public function equip(Item:Object,slot:int):void
		{
			bonusAtk += Item.atk
			bonusDef += Item.def
			refreshStats();
			equipArray[slot] = Item;			
			
			if (Item.range > 0)
			{
				atkRange = Item.range			
			}
			//trace("equipt'd",equipArray,atkRange);			
		}
		public function fillOut():void
		{			
			cMove = cMoveMax												
			dispatchEvent(new Event("hpBarUpdate", true));			
		}
		public function refreshStats():void
		{
			//Figures out HP from str + equip
			baseHp = 20 + (cStr * 1.3);			
			cMaxHp = baseHp + bonusHp;
			
			//Figures out ATK from stats + equip
			var atkFromStats:int = (cStr/3) + (cAgi/2) + (cInt/2.2)
			baseAtk = atkFromStats;
			cAtk = baseAtk + bonusAtk;
			
			//Figures out DEF from stats + equip
			var defFromStats:int = (cAgi/5)+(cInt/5)
			baseDef = defFromStats;
			cDef = baseDef + bonusDef;
		}
		public function returnDmg(returnedDmg:int)
		{
			returnedDmg * (.80 - (cDef * .01));
			cHp -=  returnedDmg;
		}
		/*public function toBeSaved():Array
		{
			var saveDataHero:Array = new Array  ;
			var stats:Array = new Array;
			var equips:Array = new Array;
			stats.push(xCo, yCo, cMove,cMoveMax,cLevel,cHp,cMaxHp,cAtk,cDef, stone, monstersKilled,currentFrame,cStr,cAgi,cInt,experience,uniqueID)
			trace("heroSavedEquip:",equipArray);
			for (var i:int=0 ; i <equipArray.length; i++)
			{
				
				if (equipArray[i] == null)
				{
					equips.push(-1)
				}
				else
				{
				equips.push(equipArray[i].item_id);
				}
			}			
			trace("EquipArray:",equips);
			saveDataHero.push("H", stats,equips);
			return saveDataHero;
		}*/
		public function saveToFamily():Array
		{
			var heroSave:Array = new Array;
			var heroEquips:Array = new Array;
			//Save your equipment
			for (var i:int=0 ; i <equipArray.length; i++)
			{
				
				if (equipArray[i] == null)
				{
					heroEquips.push(-1)
				}
				else
				{
				heroEquips.push(equipArray[i].item_id);
				}
			}
			
			heroSave.push(uniqueID,heroEquips,monstersKilled,currentFrame,experience)						
			
			return heroSave;
		}
		
		public function defend():void
		{
			defending = .5;
		}
		public function movement(TilesList:Array,AllyLocation:Array,aimX:int,aimY:int,MapArray:Array,UnitLocations:Array):void
		{
			tileList = TilesList;
			allyLocation = AllyLocation;
			unitLocations = UnitLocations;

			var pathfind:Path = new Path(this,aimX,aimY,MapArray,unitLocations);
			var myPath:Array = pathfind.getPath();			
			movePath = myPath;				
			pathfind.goExit()
			if (movePath.length > 0 && movePath[movePath.length-1].moveCost <= cMove)
			{
				dispatchEvent(new Event("moving",true));
				movementTimer.addEventListener(TimerEvent.TIMER, makeMove);
				
				cMove = 0;
				//cMove -=  movePath[movePath.length-1].moveCost;
				movementTimer.start();				
			}
		}
		public function makeMove(e:TimerEvent):void
		{
			if (movePath.length > 0)
			{

				if (movePathCounter == 0 && allyLocation[yCo][xCo] == this)
				{
					tileList[yCo][xCo].occupied = false;
					allyLocation[yCo][xCo] = null;
					unitLocations[yCo][xCo] = null;
				}
				xCo = movePath[0].xCo;
				yCo = movePath[0].yCo;
				x = xCo * 32;
				y = yCo * 32;
				movePath.shift();
				movePathCounter++;
				//checked in GameControl				

			}
			else
			{			
				tileList[yCo][xCo].occupied = true;
				allyLocation[yCo][xCo] = this;
				unitLocations[yCo][xCo] = this;
				movePathCounter = 0;
				movementTimer.stop();
				dispatchEvent(new Event("doneMoving", true));							
				movementTimer.removeEventListener(TimerEvent.TIMER, makeMove);

			}
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
			return newArray;
		}
		public function takeDmg(physDmg:int,splDmg:int):void
		{
			if ((cHp > 0))
			{
				if ((physDmg > 0))
				{
					physDmg -=  cDef;
					
					if ((physDmg < 0))
					{
						physDmg = 0;
					}
					else
					{
						physDmg -= physDmg * defending
						cHp -=  physDmg;
						
						if (cHp <= 0)
						{
							cHp=0;
							trace("died for your sins");
							dispatchEvent(new Event("hpBarUpdate", true));
							dispatchEvent(new Event("dead", true));
						}
						else
						{
							dispatchEvent(new Event("hpBarUpdate", true));
						}
						
						//possible death code
					}
				}
			}
		}
	}

}