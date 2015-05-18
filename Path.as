package 
{

	import flash.display.MovieClip;
	import flash.utils.getQualifiedSuperclassName;

	public class Path extends MovieClip
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

		public function Path(Character:Object, targetX:int, targetY:int, MapArray:Array, UnitLocations:Array)
		{
			//To Use:
			
			//Call class
			//Grab movepath:Array with getPath()
			//Put up for garbage collection with doExit();
			
			myPath = new Array  ;
			openList = new Array  ;

			mapArray = newTheMap(MapArray);
			groundMap = newTheMap(MapArray);
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

			}
			else
			{

				if (checkB(nN.xCo+1,nN.yCo))
				{
					checkNode(nN,nN.xCo + 1, nN.yCo)
				}
				if (checkB(nN.xCo-1,nN.yCo))
				{
					checkNode(nN,nN.xCo - 1, nN.yCo)
				}
				if (checkB(nN.xCo+1,nN.yCo+1))
				{
					checkNode(nN,nN.xCo, nN.yCo + 1)
				}
				if (checkB(nN.xCo+1,nN.yCo-1))
				{
					checkNode(nN,nN.xCo, nN.yCo - 1)
				}

				whosNext();

			}

		}
		private function checkNode(nN:Object,xCo:int,yCo:int):void
		{
			if (groundMap[yCo][xCo] is nodes)
			{
				if (nN.g < groundMap[yCo][xCo].myParent.g)
					{
						
						groundMap[yCo][xCo].myParent = nN;
						groundMap[yCo][xCo].g = (nN.g+10);
						groundMap[yCo][xCo].strategize();
						
						var nodeChange:Object = groundMap[yCo][xCo];
						openList.push({object: nodeChange, f:nodeChange.f, h:nodeChange.h, g: nodeChange.g});

					}
			}
			else if (mapArray[yCo][xCo] != 1 && (unitLocations[yCo][xCo] == null || getQualifiedSuperclassName(character) == getQualifiedSuperclassName(unitLocations[yCo][xCo])) || (xCo == nN.aimX && yCo == nN.aimY))
				{
					var node:nodes = new nodes(nN,xCo,yCo,aimX,aimY,groundMap[yCo][(xCo)]);
					openList.push({object: node, f: node.f, h: node.h, g: node.g});
					groundMap[yCo][xCo] = node;
				}
		}
		private function checkB(xCo:int,yCo:int):Boolean
		{
			var inBounds:Boolean = false
			
			if (xCo >= 0 && xCo < mapArray[0].length && yCo >= 0 && yCo < mapArray.length)
			{
				inBounds = true;
			}
			
			return inBounds
		}
		private function tracePath():void
		{
			trace("*------------------------*");
			for (var i:int=0; i < groundMap.length; i++)
			{
				var neatgroundMap:Array = new Array  ;
				neatgroundMap[i] = newTheMap(groundMap)[i];
				
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
	}

}