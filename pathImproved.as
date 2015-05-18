package 
{

	import flash.display.MovieClip;


	public class pathImproved extends MovieClip
	{



		private var aimX:int;
		private var aimY:int;

		private var openList:Array;
		private var mapArray:Array;
		private var groundMap:Array;
		private var unitLocations:Array;

		private var newNode:nodes;

		private var myPath:Array;

		private var eMove:int;
		
		private var character:Object;
		
		public var g:int = 0;

		public function pathImproved(Character:Object, targetX:int, targetY:int, MapArray:Array, UnitLocations:Array)
		{
			//To Use:
			//Call class
			//Grab movepath with getPath()
			//Put up for garbage collection with doExit();
			
			myPath = new Array  ;
			openList = new Array  ;

			mapArray = newgroundMap(MapArray);
			groundMap = newgroundMap(MapArray);
			unitLocations = UnitLocations;

			aimX = targetX;
			aimY = targetY;
			
			character = Character;

			if (character is Hero)
			{
				eMove = character.cMove;
			}
			else if (character is Enemy)
			{
				eMove = character.eMove;
			}

			newNode = new nodes(this,character.xCo,character.yCo,targetX,targetY,0);

			groundMap[newNode.yCo][newNode.xCo] = newNode;
		}
		
		private function nextCheck(nextUp:Object):void
		{
			var nN:Object = nextUp;
			var nodeChange:Object;

			if (nN.xCo == nN.aimX && nN.yCo == nN.aimY)
			{
				myPath.push(nN);
				while (nN.myParent != this)
				{
					nN = nN.myParent;					
					myPath.push(nN);
				}

				myPath.reverse();
				myPath.shift();

				if (openList.length > 0)
				{
					openList = [];
				}

				groundMap = [];

			}
			else
			{

				var node:nodes;

				if (nN.xCo +1 < groundMap[nN.yCo].length && groundMap[nN.yCo][nN.xCo + 1] is nodes)
				{
					
					if (nN.g < groundMap[nN.yCo][nN.xCo+1].myParent.g)
					{
						groundMap[nN.yCo][nN.xCo + 1].myParent = nN;
						groundMap[nN.yCo][nN.xCo + 1].g = (nN.g+10);
						groundMap[nN.yCo][nN.xCo + 1].strategize();
						
						nodeChange = groundMap[nN.yCo][nN.xCo + 1];
						openList.push({object: nodeChange, f:nodeChange.f, h:nodeChange.h, g: nodeChange.g});
					}
				}
				else if (nN.xCo +1 < groundMap[nN.yCo].length && mapArray[nN.yCo][nN.xCo+1] != 1 && (unitLocations[nN.yCo][nN.xCo+1] == null || unitLocations[nN.yCo][nN.xCo+1].constructor == character.constructor))
				{

					node = new nodes(nN,nN.xCo + 1,nN.yCo,aimX,aimY,mapArray[nN.yCo][nN.xCo + 1]);
					openList.push({object: node, f: node.f, h: node.h, g: node.g});
					groundMap[nN.yCo][nN.xCo + 1] = node;
				}

				if (nN.xCo -1 >= 0 && groundMap[nN.yCo][nN.xCo-1] is nodes)
				{
					
					if (nN.g < groundMap[nN.yCo][nN.xCo-1].myParent.g)
					{
						
						groundMap[nN.yCo][nN.xCo - 1].myParent = nN;
						groundMap[nN.yCo][nN.xCo - 1].g = (nN.g+10);
						groundMap[nN.yCo][nN.xCo - 1].strategize();
						
						nodeChange = groundMap[nN.yCo][nN.xCo - 1];
						openList.push({object: nodeChange, f:nodeChange.f, h:nodeChange.h, g: nodeChange.g});
					}
				}
				else if (nN.xCo -1 >= 0 && mapArray[nN.yCo][nN.xCo-1] != 1 && (unitLocations[nN.yCo][nN.xCo-1] == null || unitLocations[nN.yCo][nN.xCo-1].constructor == character.constructor))
				{
					node = new nodes(nN,nN.xCo - 1,nN.yCo,aimX,aimY,mapArray[nN.yCo][(nN.xCo - 1)]);
					openList.push({object: node, f: node.f, h: node.h, g: node.g});
					groundMap[nN.yCo][(nN.xCo - 1)] = node;
				}

				if ((nN.yCo + 1) < groundMap.length && groundMap[nN.yCo + 1][nN.xCo] is nodes)
				{
					
					if (nN.g < groundMap[nN.yCo+1][(nN.xCo)].myParent.g)
					{
						
						groundMap[nN.yCo + 1][nN.xCo].myParent = nN;
						groundMap[nN.yCo +1][nN.xCo].g = (nN.g+10);
						groundMap[nN.yCo + 1][nN.xCo].strategize();
						
						nodeChange = groundMap[nN.yCo + 1][nN.xCo];
						openList.push({object: nodeChange, f:nodeChange.f, h:nodeChange.h, g: nodeChange.g});
						
					}
				}
				else if ((nN.yCo + 1) < groundMap.length && mapArray[nN.yCo+1][nN.xCo] != 1 && (unitLocations[nN.yCo+1][nN.xCo] == null || unitLocations[nN.yCo+1][nN.xCo].constructor == character.constructor))
				{
					node = new nodes(nN,nN.xCo,nN.yCo + 1,aimX,aimY,mapArray[nN.yCo+1][(nN.xCo)]);
					openList.push({object: node, f: node.f, h: node.h, g: node.g});
					groundMap[nN.yCo+1][(nN.xCo )] = node;
				}

				if ((nN.yCo -1) >= 0 && groundMap[nN.yCo - 1][nN.xCo] is nodes)
				{
					
					if (nN.g < groundMap[nN.yCo-1][(nN.xCo)].myParent.g)
					{
						
						groundMap[nN.yCo - 1][nN.xCo].myParent = nN;
						groundMap[nN.yCo -1][nN.xCo].g = (nN.g+10);
						groundMap[nN.yCo - 1][nN.xCo].strategize();
						
						nodeChange = groundMap[nN.yCo - 1][nN.xCo];
						openList.push({object: nodeChange, f:nodeChange.f, h:nodeChange.h, g: nodeChange.g});

					}
				}
				else if ((nN.yCo -1) >= 0 && mapArray[nN.yCo-1][nN.xCo] != 1 && (unitLocations[nN.yCo-1][nN.xCo] == null || unitLocations[nN.yCo-1][nN.xCo].constructor == character.constructor))
				{
					node = new nodes(nN,nN.xCo,nN.yCo - 1,aimX,aimY,groundMap[nN.yCo-1][(nN.xCo)]);
					openList.push({object: node, f: node.f, h: node.h, g: node.g});
					groundMap[nN.yCo-1][(nN.xCo )] = node;
				}
				
				whosNext();

			}

		}
		private function tracePath():void
		{
			trace("*------------------------*");
			for (var i:int=0; i < groundMap.length; i++)
			{
				var neatgroundMap:Array = new Array  ;
				neatgroundMap[i] = newgroundMap(groundMap)[i];

				for (var p:int=0; p<groundMap[i].length; p++)
				{
					if (neatgroundMap[i][p] is Hero)
					{
						neatgroundMap[i][p] = "H";
					}
					if (neatgroundMap[i][p] is nodes)
					{
						neatgroundMap[i][p] = "N";
					}
					if (neatgroundMap[i][p] is Enemy)
					{
						neatgroundMap[i][p] = "E";
					}
					if (i == aimY && p == aimX)
					{
						neatgroundMap[i][p] = "T";
					}
					for (var k:int =0; k<myPath.length; k++)
					{
						if (i == myPath[k].yCo && p == myPath[k].xCo)
						{
							neatgroundMap[i][p] = "P";
						}
					}

				}
				trace(neatgroundMap[i]);
			}
			trace("*------------------------*");
		}
		private function whosNext():void
		{
			if (openList.length > 0)
			{

				openList.sortOn(["f","h","g"], [Array.NUMERIC,Array.DESCENDING,Array.NUMERIC]);

				newNode = openList[0].object;

				openList.shift();
				nextCheck(newNode);
			}

		}
		public function getPath():Array
		{
			var charPath:Array = new Array  ;
			nextCheck(newNode);
			charPath = myPath;
			return charPath;
		}
		public function goExit():void
		{
			mapArray = null;
			groundMap = null;
			unitLocations = null;
			
			openList = null;
	
			newNode = null;
			myPath = null;
			character = null;
			
		}
		private function newgroundMap(array:Array):Array
		{
			var newArray:Array = new Array  ;
			for (var i:int = 0; i < array.length; i++)
			{
				var content:* = array[i];
				if (content is Array)
				{
					newArray[i] = newgroundMap(content);
				}
				else
				{
					newArray[i] = content;
				}
			}
			return newArray;
		}
	}

}