package 
{

	import flash.display.MovieClip;
	import flash.sensors.Accelerometer;
	import flash.geom.Point;


	public class AssessGround extends MovieClip
	{

		private var unitLocations:Array;
		private var prepareSpot:Array;
		private var conflictZoneList:Array;
		private var prio0:Array;
		private var conflictList:Array;
		private var conflict:Boolean;
		private var movesList:Array;
		private var enemyMoves:Array;
		private var enemyList:Array;
		private var enemyAttacks:Array;
		private var enemyVision:Array;
		private var enemySighted:Array;
		private var enemy:MovieClip;
		private var mapWidth:int;
		private var mapHeight:int;
		private var groundMap:Array;
		private var tileList:Array;
		private var enemyLocation:Array;
		private var allyLocation:Array;
		private var mapArray:Array;
		private var origAllyMap:Array;

		private var plottedPts:Array;


		public function AssessGround(MapWidth:int,MapHeight:int, GroundMap:Array, EnemyList:Array, TilesList:Array,EnemyLocation:Array,AllyLocation:Array,UnitLocations:Array)
		{

			unitLocations = UnitLocations;
			prepareSpot = new Array  ;
			conflictZoneList = new Array  ;
			prio0 = new Array  ;

			conflictList = new Array  ;
			movesList = new Array  ;
			tileList = new Array  ;
			tileList = TilesList;

			enemyLocation = new Array  ;
			enemyLocation = EnemyLocation;
			origAllyMap = new Array  ;
			origAllyMap = AllyLocation;
			allyLocation = new Array  ;
			allyLocation = newTheMap(AllyLocation);
			mapArray = new Array  ;
			mapArray = GroundMap;
			enemyList = EnemyList;
			enemyMoves = new Array  ;
			groundMap = new Array  ;
			groundMap = newTheMap(GroundMap);
			mapWidth = MapWidth;
			mapHeight = MapHeight;
			enemyAttacks = new Array  ;
			enemyVision = new Array  ;
			enemySighted = new Array  ;


			// constructor code
		}
		public function startAssessment()
		{
			groundMap = newTheMap(mapArray);
			allyLocation = newTheMap(origAllyMap);
			enemyMoves = new Array  ;
			for (var i:int=0; i<enemyList.length; i++)
			{
				assessAreaRoy(i);
				addEnemy(enemyList[i]);
			}
			if (enemyMoves.length > 0)
			{
				decideTurns();
			}
			else
			{
				exit();
				trace("no moves");
			}

		}
		public function addEnemy(Enemy:MovieClip)
		{
			enemy = Enemy;
			enemyAttacks = enemy.enemyAttacks;
			enemySighted = enemy.enemySighted;
			enemyVision = newTheMap(enemy.enemySight);
			assessStrategicValue();
		}
		public function assessAreaRoy(enemyIndex:int):void
		{
			var index:int = enemyIndex;
			var xCo:int = enemyList[index].xCo;
			var yCo:int = enemyList[index].yCo;
			var vision:int = enemyList[index].eVision;

			enemyList[index].enemySight = new Array  ;
			for (var o:int=0; o < mapHeight; o++)
			{
				enemyList[index].enemySight.push(new Array);
				for (var k:int=0; k < mapWidth; k++)
				{
					enemyList[index].enemySight[o].push(null);
				}
			}


			enemyList[index].enemySighted = new Array  ;
			enemyList[index].alliedSighted = new Array  ;
			for (var i:int = -vision; i <= vision; i++)
			{
				for (var p:int = -vision; p <= vision; p++)
				{
					var distance:int = Math.abs(xCo - (xCo+p)) + Math.abs(yCo - (yCo+i));
					if ((yCo+i >= 0 && yCo+i < mapHeight && xCo + p >= 0 && xCo + p < mapWidth) && distance <= vision)
					{
						if (tileList[yCo + i][xCo + p].occupied == true)
						{
							if (enemyLocation[yCo + i][xCo + p] is Enemy)
							{
								enemyList[index].enemySight[yCo + i][xCo + p] = enemyLocation[yCo + i][xCo + p];
								enemyList[index].alliedSighted.push(enemyLocation[yCo+i][xCo+p]);
							}
							else if (origAllyMap[yCo+i][xCo+p] is Hero)
							{
								enemyList[index].enemySight[yCo + i][xCo + p] = origAllyMap[yCo + i][xCo + p];
								enemyList[index].enemySighted.push(origAllyMap[yCo+i][xCo+p]);
							}
						}
						else
						{
							enemyList[index].enemySight[yCo + i][xCo + p] = newInt(mapArray[yCo + i][xCo + p]);
						}
					}
				}
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
		private function assessStrategicValue()
		{
			//var enemy must = enemy assessingStrategy
			enemyAttacks.sortOn("range", Array.DESCENDING | Array.NUMERIC);
			var possibleSpots:Array = new Array  ;
			var dmgPotential:int = 0;
			var attackRange:int = 0;

			var dijkPath:DijkPath = new DijkPath(enemy,mapArray,unitLocations);
			var moveableSpaces:Array = dijkPath.getMapArray();
			dijkPath.doExit();
			
			var plottedPts:Array = newTheMap(mapArray);
			
			for (var k:int = 0; k < enemySighted.length; k++)
			{
				
				for (var q:int=0; q < enemyAttacks.length; q++)
				{
					attackRange = enemyAttacks[q].range;
					dmgPotential = enemyAttacks[q].dmg;
					
					for (var p:int=-attackRange; p<=attackRange; p++)
					{

						for (var o:int=-attackRange; o<=attackRange; o++)
						{

							
							//is within boundaries and is a moveable space
							if ((enemySighted[k].yCo + p >= 0 && enemySighted[k].xCo + o >=0 && enemySighted[k].yCo + p < mapHeight && enemySighted[k].xCo +o < mapWidth) && moveableSpaces[enemySighted[k].yCo + p][enemySighted[k].xCo + o] is DijkNode)
							{
								
								//check if within range of attack
								if ((Math.abs(enemySighted[k].yCo - (enemySighted[k].yCo + p)) + Math.abs(enemySighted[k].xCo - (enemySighted[k].xCo + o))) <=attackRange)
								{
									
									//exclude spots on top of hero
									if (!(enemyVision[enemySighted[k].yCo + p][enemySighted[k].xCo + o] is Hero))
									{
										
										//assign relative node
										var moveableNode:DijkNode = moveableSpaces[enemySighted[k].yCo + p][enemySighted[k].xCo + o];
										var checkNode:Object = {targetHero:Object,mapValue:int,xCo:int,yCo:int,dist:int,enemy:enemy,importance:int,conflicted:Boolean,bigBro:Array,pt:Point,dmgPotential:int,myParent:int,globalScore:int,attackName:String};
										checkNode.attackName = enemyAttacks[q];
										checkNode.myParent = enemyList.indexOf(enemy);
										checkNode.targetHero = enemySighted[k];
										checkNode.globalScore = 0;
										checkNode.bigBro = new Array  ;
										checkNode.conflicted = false;
										checkNode.dist = moveableNode.dist;
										checkNode.mapValue = mapArray[(enemySighted[k].yCo + p)][(enemySighted[k].xCo + o)];
										checkNode.xCo = (enemySighted[k].xCo + o);
										checkNode.yCo = (enemySighted[k].yCo + p);
										checkNode.pt = new Point(checkNode.xCo,checkNode.yCo);
										plottedPts[checkNode.yCo][checkNode.xCo] = checkNode;
										checkNode.enemyTarget = enemySighted[k];

										if (checkNode.mapValue is Enemy)
										{
											checkNode.mapValue = groundMap[enemySighted[k].yCo + p][enemySighted[k].xCo + o];
											trace("should not happen");
										}
										switch (checkNode.mapValue)
										{
												//also change @ enemy: switch (aim.mapValue)
											case Enemy :
												break;

											case 0 :
												checkNode.dmgPotential = dmgPotential;
												break;

											case 2 :
												checkNode.dmgPotential = dmgPotential * 1.2;
												break;

											case 3 :
												checkNode.dmgPotential = dmgPotential * 1.2;
												break;

											case 4 :
												checkNode.dmgPotential = dmgPotential;
												break;

											case 6 :
												checkNode.dmgPotential = dmgPotential;
												break;
										}
										
										possibleSpots.push(checkNode);
									}
								}
							}
						}
					}

				}
			}

			runPaths(possibleSpots,plottedPts);
			newRunPaths(possibleSpots,plottedPts);

			if (possibleSpots.length == 1)
			{
				
				possibleSpots[0].importance = 0;
				enemyMoves.push(possibleSpots[0]);
				movesList.push(possibleSpots);
			}
			if (possibleSpots.length > 1)
			{
				possibleSpots.sortOn(["dmgPotential","dist"], [Array.DESCENDING | Array.NUMERIC, Array.NUMERIC]);

				var a:int = 0;
				var b:int = 0;
				while (a < possibleSpots.length && possibleSpots[a].dmgPotential == possibleSpots[b].dmgPotential)
				{
					possibleSpots[a].importance = a;
					enemyMoves.push(possibleSpots[a]);
					a++;
					if (a != possibleSpots.length && possibleSpots[a].dmgPotential != possibleSpots[b].dmgPotential)
					{
						b = a;
					}
				}
				movesList.push(possibleSpots);
			}

		}

		public function decideTurns():void
		{

			if (enemyMoves.length == 1)
			{
				enemyMoves[0].enemy.aim = enemyMoves[0];
				exit();
			}
			else if (enemyMoves.length > 1)
			{
				//trace("eMoves 1+");
				enemyMoves.sortOn(["importance","dmgPotential","dist"], [Array.NUMERIC, Array.DESCENDING,Array.NUMERIC]);

				for (var i:int=0; i<enemyMoves.length; i++)
				{

					if (enemyMoves[i].importance != 0 || i + 1 == enemyMoves.length)
					{

						while (conflict == true)
						{
							/*var fgh:Array = newTheMap(mapArray);
							for (var gm2:int=0; gm2<conflictList.length; gm2++)
							{
							fgh[conflictList[gm2].yCo][conflictList[gm2].xCo] = "G";
							}
							for (var gm:int=0; gm < groundMap.length; gm++)
							{
							for (var kq:int=0; kq<groundMap[gm].length; kq++)
							{
							if (fgh[gm][kq] is int)
							{
							fgh[gm][kq] = "+";
							}
							}
							trace(fgh[gm]);
							}
							trace("New conflicts");*/
							analyzeConflicts();
							//doit - 7/4/13
							conflictZoneList = new Array  ;
							for (var p:int=0; p<prio0.length; p++)
							{
								var conflictZone:Array = new Array  ;
								conflictZone.push(prio0[p]);
								for (var s:int=0; s<prio0[p].bigBro.length; s++)
								{
									conflictZone.push(prio0[p].bigBro[s]);
								}
								conflictZoneList.push(conflictZone);
							}

							prio0 = new Array  ;
							runConflicts();
							conflictList = new Array  ;






							//trace("*------------*");
							prepareSpot = new Array  ;
							for (var t:int=0; t < conflictZoneList.length; t++)
							{
								//trace(conflictZoneList[t].length);
								//trace(conflictZoneList[t][0].pt);
								checkWinner(conflictZoneList[t]);
								//trace("*****");
							}
							//showVision(groundMap);
							//trace(prepareSpot)
							for (var t2:int=0; t2 < prepareSpot.length; t2++)
							{
								spotMap(prepareSpot[t2]);
							}
							//trace(conflict);



						}

						exit();
						break;


					}
					//trace("a");
					spotMap(i);
				}
			}
		}
		private function spotMap(i:int):void
		{

			//trace(enemyMoves.indexOf(groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo]))
			if (enemyMoves.indexOf(groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo]) >= 0)
			{
				conflict = true;
				conflictList.push(enemyMoves[i]);
				if (conflictList.indexOf(groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo]) == -1)
				{
					conflictList.push(groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo]);
					//enemy who was stepped on marks "27" on sight to tell self this is an area of conflicted interest;
					groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo].enemy.enemySight[enemyMoves[i].yCo][enemyMoves[i].xCo] = 27;
					groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo].bigBro = new Array  ;
				}
				groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo].bigBro.push(enemyMoves[i]);
				//enemy marks 27 to show conflict on own sight;
				enemyMoves[i].enemy.enemySight[enemyMoves[i].yCo][enemyMoves[i].xCo] = 27;

				//prio0 is composed of nodes which were first to plot point of graph before conflict
				//they each contain a "bigBro" array that has the list of everyone conflicted for the stop
				if (prio0.indexOf(groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo]) == -1)
				{
					prio0.push(groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo]);
				}

			}
			else
			{
				groundMap[enemyMoves[i].yCo][enemyMoves[i].xCo] = enemyMoves[i];
				enemyMoves[i].enemy.aim = enemyMoves[i];
			}

			enemyMoves[i].bestAttack = new Array  ;

		}
		private function checkWinner(newSort:Array):void
		{

			newTheMap(newSort);
			newSort.sortOn(["globalScore","dist"], [Array.DESCENDING, Array.NUMERIC]);
			/*for (var qs:int=0; qs < newSort.length; qs++)
			{
			trace("impo",newSort[qs].importance,"GS",newSort[qs].globalScore,"dist",newSort[qs].dist,"dmgpot",newSort[qs].dmgPotential,"uPt",newSort[qs].enemy.xCo,":",newSort[qs].enemy.yCo);
			}*/

			newSort[0].enemy.aim = newSort[0];
			groundMap[newSort[0].yCo][newSort[0].xCo] = newSort[0];

			for (var pp = 1; pp < newSort.length; pp++)
			{

				prepareSpot.push(enemyMoves.indexOf(newSort[pp].bestAttack[0]));

			}

		}


		private function newRunPaths(possibleSpots:Array,moveableSpaces:Array):void
		{
			var dijkPath:DijkPath = new DijkPath(enemy,mapArray,unitLocations);
			var closedList:Array = dijkPath.getClosedList();
			dijkPath.doExit();
			for (var pk:int=0; pk < closedList.length; pk++)
			{
				if (moveableSpaces[closedList[pk].yCo][closedList[pk].xCo] is int)
				{
					var checkNode:Object = {targetHero:Object,mapValue:int,xCo:int,yCo:int,dist:int,enemy:enemy,importance:int,conflicted:Boolean,bigBro:Array,pt:Point,dmgPotential:int,myParent:int,globalScore:int,attackName:String};
					checkNode.myParent = enemyList.indexOf(enemy);
					checkNode.globalScore = 0;
					checkNode.bigBro = new Array  ;
					checkNode.conflicted = false;
					checkNode.dist = closedList[pk].dist;
					checkNode.mapValue = mapArray[closedList[pk].yCo][closedList[pk].xCo];
					checkNode.xCo = closedList[pk].xCo;
					checkNode.yCo = closedList[pk].yCo;
					checkNode.pt = new Point(checkNode.xCo,checkNode.yCo);
					checkNode.dmgPotential = 0;
					possibleSpots.push(checkNode);
					moveableSpaces[closedList[pk].yCo][closedList[pk].xCo] = checkNode;
				}

			}
		}
		private function runPaths(possibleSpots:Array,moveableSpaces:Array):void
		{
			for (var i:int = 0; i < enemySighted.length; i++)
			{

				//showVision(enemyVision);
				var pathfind:Path = new Path(enemy,enemySighted[i].xCo,enemySighted[i].yCo,mapArray,unitLocations);
				var myPath:Array = pathfind.getPath();
				myPath.pop();

				pathfind.goExit();
				for (var k:int = 0; k < myPath.length; k++)
				{

					if (k == enemy.eMoveMax)
					{

						break;
					}
					//trace(myPath[k].xCo,pathfind.myPath[k].yCo);
					if ((myPath.length > 0 && myPath[k].moveCost > enemy.eMove))
					{

					}
					else if (moveableSpaces[myPath[k].yCo][myPath[k].xCo] is int)
					{
						var newNode:Object = {targetHero:Object,mapValue:int,xCo:int,yCo:int,dist:int,enemy:enemy,importance:int,conflicted:Boolean,bigBro:Array,pt:Point,dmgPotential:int,myParent:int,globalScore:int};
						newNode.myParent = enemyList.indexOf(enemy);
						newNode.targetHero = enemySighted[i];
						newNode.globalScore = 0;
						newNode.bigBro = new Array  ;
						newNode.conflicted = false;
						newNode.dist = (k + 1) * -1;
						newNode.mapValue = mapArray[myPath[k].yCo][myPath[k].xCo];
						newNode.xCo = myPath[k].xCo;
						newNode.yCo = myPath[k].yCo;
						newNode.pt = new Point(myPath[k].xCo,myPath[k].yCo);
						newNode.dmgPotential = 0;
						possibleSpots.push(newNode);
						moveableSpaces[myPath[k].yCo][myPath[k].xCo] = newNode;
					}

				}
			}
		}


		private function analyzeConflicts():void
		{


			conflict = false;
			for (var g:int; g<conflictList.length; g++)
			{

				var noMoves:Boolean = false;
				var importanceSub:int = conflictList[g].importance;
				//trace("*---------1---------*");
				//trace(conflictList[g].importance);
				//trace(movesList[enemyList.indexOf(conflictList[g].enemy)].length);

				//trace(conflictList[g].importance )
				//trace(movesList[enemyList.indexOf(conflictList[g].enemy)].length)
				if (importanceSub + 1< movesList[enemyList.indexOf(conflictList[g].enemy)].length)
				{

					var whileIsOn:Boolean = false;
					//trace("new");
					//only runs IF the next one is unuseable.
					while ((movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1].pt.equals(conflictList[g].pt) || conflictList[g].enemy.enemySight[movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1].yCo][movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1].xCo] == 27) || (origAllyMap[movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1].yCo][movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1].xCo] != null))
					{

						if ((importanceSub + 2) >= movesList[enemyList.indexOf(conflictList[g].enemy)].length)
						{
							importanceSub++;
							//trace("last move for (x,y):",conflictList[g].enemy.xCo,conflictList[g].enemy.yCo, "index:",enemyList.indexOf(conflictList[g].enemy));

							//if something goes wrong, it's probably cause I commented out this next while statement


							/*while ((movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub].pt.equals(conflictList[g].pt) || conflictList[g].enemy.enemySight[movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub].yCo][movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub].xCo] == 27) || (origAllyMap[movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub].yCo][movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub].xCo] != null))
							{
							//trace("no moves left that work");
							//trace("original move:",conflictList[g].pt);
							noMoves = true;
							break;
							}*/

							//|| (!(groundMap[movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1].yCo][movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1].xCo] is Number) && groundMap[movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1].yCo][movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1].xCo].importance == 0) 
							trace("last move");
							noMoves = true;
							break;
						}
						importanceSub++;
						//trace("skipone: ",importanceSub)
					}
				}
				else
				{
					//trace("only or last move");
					//trace(conflictList[g].pt,conflictList[g].enemy.xCo,conflictList[g].enemy.yCo,enemyList.indexOf(conflictList[g].enemy));
					trace("+1 is less than moves");
					noMoves = true;
				}
				//trace("*----------2--------*");


				//if (noMoves == false && enemyMoves.indexOf(movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1]) != -1)
				//i'm pretty sure you don't need the second part of this if statement but just in case: ^^^
				if (noMoves == false)
				{

					//grabs the next useable node
					var nextObj:Object = movesList[enemyList.indexOf(conflictList[g].enemy)][importanceSub + 1];
					nextObj.myPredi = conflictList[g];
					nextObj.globalScore = 0;

					if (conflictList[g].importance == 0)
					{
						conflictList[g].globalScore = nextObj.globalScore.toFixed(3);
					}
					nextObj.myPredi.bestAttack.unshift(nextObj);


				}
				else
				{
					var badNode:Object = {prio:int,targetHero:Object,mapValue:int,xCo:int,yCo:int,dist:int,enemy:conflictList[g].enemy,importance:int,conflicted:Boolean,tier:int,bigBro:Array,moveCost:Number,pt:Point,dmgPotential:int,myParent:int,globalScore:int,conflictSq:int,unconflictSq:int,attackName:String};
					badNode.myParent = enemyList.indexOf(conflictList[g].enemy);
					badNode.myPredi = conflictList[g];
					badNode.globalScore=999;
					badNode.bigBro = new Array  ;
					badNode.conflicted = false;
					badNode.dist = 0;
					badNode.mapValue = mapArray[conflictList[g].enemy.yCo][conflictList[g].enemy.xCo];
					badNode.xCo = (conflictList[g].enemy.xCo);
					badNode.yCo = (conflictList[g].enemy.yCo);
					badNode.pt = new Point(badNode.enemy.xCo,badNode.enemy.yCo);
					badNode.dmgPotential = 999;
					enemyMoves.push(badNode);
					conflictList[g].bestAttack.unshift(badNode);

				}

			}

		}
		private function runConflicts():void
		{

			for (var h:int=0; h<conflictZoneList.length; h++)
			{

				var czl = conflictZoneList[h];
				for (var q:int=0; q<czl.length; q++)
				{

					var total:int = 0;
					total +=  czl[q].dmgPotential;



					for (var i:int=0; i<czl.length; i++)
					{
						if (i != q)
						{
							//trace("their totals: ",movesList[czl[i].myParent][0].bestAttack[0].dmgPotential);
							//trace("their x/y: ",movesList[czl[i].myParent][0].bestAttack[0].xCo,movesList[czl[i].myParent][0].bestAttack[0].yCo);


							total +=  czl[i].bestAttack[0].dmgPotential;

						}
					}
					
					czl[q].globalScore = total;
					movesList[czl[q].myParent][0].globalScore = total;
				}
			}
		}


		private function newInt(intReturned:int):int
		{
			return intReturned;
		}
		private function showVision(v:Array):void
		{
			var iWonder:Array = new Array  ;
			iWonder = newTheMap(v);
			for (var qw:int=0; qw<iWonder.length; qw++)
			{
				for (var wq:int=0; wq < iWonder[qw].length; wq++)
				{
					if (!(iWonder[qw][wq] >= 0))
					{

						if (iWonder[qw][wq] is Hero)
						{
							iWonder[qw][wq] = "H";
						}
						else if (iWonder[qw][wq] is Enemy)
						{
							iWonder[qw][wq] = "E";
						}
						else if (iWonder[qw][wq] == 27)
						{
							iWonder[qw][wq] = 9;
						}
					}


				}
				trace(iWonder[qw]);
			}
		}
		public function exit():void
		{



			prepareSpot = new Array  ;
			conflictZoneList = new Array  ;
			prio0 = new Array  ;

			conflictList = new Array  ;
			conflict = false;
			movesList = new Array  ;
			//enemyMoves = new Array  ;
			enemyAttacks = new Array  ;
			enemyVision = new Array  ;
			enemySighted = new Array  ;
			enemy = null;
			mapWidth:int;
			mapHeight:int;
			enemyLocation:Array;
			allyLocation:Array;
			mapArray:Array;
			origAllyMap:Array;


		}



	}

}