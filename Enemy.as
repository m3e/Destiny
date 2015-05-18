package
{

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import sounds.SoundManager;


	public class Enemy extends MovieClip
	{
		private var movePathCounter:int;
		private var unitLocations:Array;
		public var enemyAttacks:Array;
		private var enemyLocation:Array;
		private var tileList:Array;
		public var movePath:Array;
		public var movementTimer:Timer = new Timer(20);
		public var alliedSighted:Array;
		public var enemySight:Array;
		public var enemySighted:Array;
		public var eHp:int;
		public var eMaxHp:int;
		public var eDef:int;
		public var eMagDef:int;
		public var eAtk:int;
		public var eReturnDmg:int;
		public var eMoveMax:int;
		public var eVision:int;
		public var xCo:int;
		public var yCo:int;
		public var aim:Object;
		public var eMove:int;
		public var coinGain:int;
		public var xpGain:int;

		public function Enemy(xCoords:int,yCoords:int)
		{
			enemyAttacks = new Array  ;
			enemySighted = new Array  ;
			coinGain = 5;
			xpGain = 15;
			eMaxHp = 15;
			eHp = eMaxHp;
			eDef = 0;
			eMagDef = 0;
			eAtk = 4;
			eReturnDmg = 0;
			eVision = 99;
			x = xCoords * 32;
			y = yCoords * 32;
			xCo = xCoords;
			yCo = yCoords;
			eMoveMax = 5;
			eMove = eMoveMax;
			addEventListener(Event.ADDED_TO_STAGE, assignAttackStrength);
			//trace(yCo,xCo);
			// constructor code
		}
		private function assignAttackStrength(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, assignAttackStrength);
			var melee:Object = {range:1,dmg:eAtk,name:"Melee"};
			enemyAttacks.push(melee);
			//var ranged:Object = {range:2,dmg:(eAtk * .5),name:"Ranged"};
			//enemyAttacks.push(ranged);
			enemyAttacks.sortOn("range", Array.DESCENDING);
		}
		public function takeDmg(physDmg:int):void
		{
			if ((eHp > 0))
			{
				if ((physDmg > 0))
				{
					physDmg -=  eDef;
					if ((physDmg < 0))
					{
						physDmg = 0;
					}
					else
					{
						eHp -=  physDmg;						
						if (eHp <= 0)
						{										
							dispatchEvent(new Event("eDead", true));
						}
						//possible death code
					}
				}
			}
		}



		public function calcSplDmg(splDmg:int):int
		{
			if ((splDmg > 0))
			{
				if ((eMagDef > 0))
				{
					splDmg -=  eMagDef;
					if ((splDmg <= 0))
					{
						splDmg = 0;
					}

				}

			}
			return splDmg;
		}







		public function calcPhysDmg(physDmg:int):int
		{

			if ((physDmg > 0))
			{
				if ((eDef > 0))
				{
					physDmg -=  eDef;

					if ((physDmg < 0))
					{
						physDmg = 0;
					}

				}

			}
			return physDmg;
		}


		public function movement(TilesList:Array,EnemyLocation:Array,MapArray:Array,UnitLocations:Array):void
		{			
			unitLocations = UnitLocations;
			enemyLocation = EnemyLocation;
			tileList = TilesList;
			
			var pathfind:Path = new Path(this,aim.xCo,aim.yCo,MapArray,unitLocations);
			var myPath:Array = pathfind.getPath();
			pathfind.goExit();
			
			movePath = myPath;

			if (movePath.length >= 0)
			{
				movementTimer.addEventListener(TimerEvent.TIMER, makeMove);
				movementTimer.start();
			}			

		}
		public function doAction():void
		{
			if (aim != null && aim.dmgPotential > 0 && aim.dmgPotential < 999)
			{				
				SoundManager.sfx("swordhit");
				var enemyTarget:Object = aim.targetHero;
				trace("Enemy used "+aim.attackName.name);
				trace("From: ",xCo,yCo);
				trace("On: ",enemyTarget.xCo,enemyTarget.yCo)

				aim.targetHero.takeDmg(determineDmg(),0);
			}
		}
		private function determineDmg():int
		{
			var atk:int = eAtk;
			//trace(aim.attackName);
			switch (aim.mapValue)
			{
					//also change @ assessground switch (checknode.mapvalue)
				case 0 :

					break;

				case 1 :

					break;

				case 2 :

					atk = eAtk * 1.2;
					break;

				case 3 :
					atk = eAtk * 1.2;
					break;

				case 4 :


					break;

				case 6 :

					break;

				case this :
					trace("niceee");
					break;
			}
			return atk;
		}
		public function makeMove(e:TimerEvent):void
		{

			if (movePath.length > 0)
			{

				if (movePathCounter == 0 && enemyLocation[yCo][xCo] == this)
				{
					tileList[yCo][xCo].occupied = false;
					enemyLocation[yCo][xCo] = null;
					unitLocations[yCo][xCo] = null;
				}
				xCo = movePath[0].xCo;
				yCo = movePath[0].yCo;
				x = xCo * 32;
				y = yCo * 32;
				movePath.shift();
				movePathCounter++;
			}
			else
			{
				tileList[yCo][xCo].occupied = true;
				enemyLocation[yCo][xCo] = this;
				unitLocations[yCo][xCo] = this;
				movePathCounter = 0;
				movementTimer.stop();
				doAction();
				aim = null;
				movementTimer.removeEventListener(TimerEvent.TIMER, makeMove);
				dispatchEvent(new Event("next", true));				
			}
		}
		//trace(movePath);
		public function toBeSaved():Array
		{
			var saveDataEnemy:Array = new Array  ;
			saveDataEnemy.push("E", xCo, yCo, eHp, eDef, eMagDef, eAtk, eReturnDmg, eVision);
			return saveDataEnemy;
		}



	}
}