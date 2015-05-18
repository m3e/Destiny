package 
{

	import flash.display.MovieClip;
	import flash.utils.getQualifiedSuperclassName;

	public class DijkPath extends MovieClip
	{
		private var char:Object;
		private var mapArray:Array;
		private var origMap:Array;
		private var node:DijkNode;
		private var closedList:Array;
		private var openList:Array;
		private var isEnemy:Boolean;
		private var unitLocations:Array;
		
		private var cMove:int;
		public function DijkPath(character:Object, map:Array,UnitLocations:Array)
		{
			unitLocations = newTheMap(UnitLocations);
			char = character;
			mapArray = newTheMap(map);
			origMap = newTheMap(map);
			closedList = new Array;
			openList = new Array  ;
			if (character is Enemy)
			{
				cMove = character.eMove;
				isEnemy = true;
			}
			else if (character is Hero)
			{
				cMove = character.cMove
				isEnemy = false;
			}
			
			//how to use this class:
			
			//first call DijkPath(character, mapArray)
			//get closedList by calling getArray() when you need it
			//then close it using doExit()
			
			var node:DijkNode = new DijkNode(0,char.xCo,char.yCo);
			mapArray[node.yCo][node.xCo] = node;
			openList.push(node);
			while (openList.length > 0)
			{
				openList.sortOn("dist", Array.NUMERIC);
				startPath(openList[0]);
			}			
		}
		public function getClosedList():Array
		{
			return closedList;
		}
		public function getMapArray():Array
		{
			
			return mapArray;
		}
		private function calcDist(mapValue:int):int
		{
			var distance:int;
			switch (mapValue)
			{
					//if you change these, you must change gameControls @ function moveCost
					//also change regular class Nodes

				case 0 :
					distance = 1;
					break;

				case 2 :
					distance = 2;
					break;

				case 3 :
					distance = 1;
					break;

				case 4 :
					distance = 1;
					break;

				case 6 :
					distance = 2;
					break;
			}

			return distance;
		}
		private function startPath(nN:DijkNode):void
		{			
			var mapValue:int;
			
			if (nN.xCo - 1 >= 0 && mapArray[nN.yCo][nN.xCo - 1] != 1)
			{
				
				mapValue = origMap[nN.yCo][nN.xCo - 1];
				if (mapArray[nN.yCo][nN.xCo - 1] is DijkNode)
				{
					if (mapArray[nN.yCo][nN.xCo - 1].dist > (nN.dist + calcDist(mapValue)))
					{
						mapArray[nN.yCo][nN.xCo - 1].dist = nN.dist + calcDist(mapValue)
						mapArray[nN.yCo][nN.xCo - 1].myParent = nN
					}
				}
				else if (nN.dist + calcDist(mapValue) <= cMove)
				{
					if (unitLocations[nN.yCo][nN.xCo - 1] == null || getQualifiedSuperclassName(char) == getQualifiedSuperclassName(unitLocations[nN.yCo][nN.xCo - 1]))
					{
					node = new DijkNode(nN.dist + calcDist(mapValue),nN.xCo - 1,nN.yCo);
					node.myParent = nN;
					mapArray[nN.yCo][nN.xCo - 1] = node;
					openList.push(node);
					}
					
					
				}
			}
			if (nN.xCo + 1 < mapArray[nN.yCo].length && mapArray[nN.yCo][nN.xCo + 1] != 1)
			{
				mapValue = origMap[nN.yCo][nN.xCo + 1];
				if (mapArray[nN.yCo][nN.xCo + 1] is DijkNode)
				{
					if (mapArray[nN.yCo][nN.xCo + 1].dist > (nN.dist + calcDist(mapValue)))
					{
						mapArray[nN.yCo][nN.xCo + 1].dist = nN.dist + calcDist(mapValue)
						mapArray[nN.yCo][nN.xCo + 1].myParent = nN

					}
				}
				else if (nN.dist + calcDist(mapValue) <= cMove)
				{					
					if (unitLocations[nN.yCo][nN.xCo + 1] == null || getQualifiedSuperclassName(char) == getQualifiedSuperclassName(unitLocations[nN.yCo][nN.xCo + 1]))
					{
					node = new DijkNode(nN.dist + calcDist(mapValue),nN.xCo + 1,nN.yCo);
					node.myParent = nN;
					mapArray[nN.yCo][nN.xCo + 1] = node;
					openList.push(node);
					}
					
					
				}
			}
			if (nN.yCo - 1 >= 0 && mapArray[nN.yCo - 1][nN.xCo] != 1)
			{
				mapValue = origMap[nN.yCo - 1][nN.xCo];
				if (mapArray[nN.yCo - 1][nN.xCo] is DijkNode)
				{
					if (mapArray[nN.yCo-1][nN.xCo].dist > (nN.dist + calcDist(mapValue)))
					{
						mapArray[nN.yCo-1][nN.xCo].dist = nN.dist + calcDist(mapValue)
						mapArray[nN.yCo-1][nN.xCo].myParent = nN;
					}
				}
				else if (nN.dist + calcDist(mapValue) <= cMove)
				{
					if (unitLocations[nN.yCo-1][nN.xCo] == null || getQualifiedSuperclassName(char) == getQualifiedSuperclassName(unitLocations[nN.yCo-1][nN.xCo]))
					{
					node = new DijkNode(nN.dist + calcDist(mapValue),nN.xCo,nN.yCo - 1);
					node.myParent = nN;
					mapArray[nN.yCo - 1][nN.xCo] = node;
					openList.push(node);
					}
				}
			}
			if (nN.yCo + 1 < mapArray.length && mapArray[nN.yCo + 1][nN.xCo] != 1)
			{
				mapValue = origMap[nN.yCo + 1][nN.xCo];
				if (mapArray[nN.yCo + 1][nN.xCo] is DijkNode)
				{
					if (mapArray[nN.yCo+1][nN.xCo].dist > (nN.dist + calcDist(mapValue)))
					{
						mapArray[nN.yCo+1][nN.xCo].dist = nN.dist + calcDist(mapValue)
						mapArray[nN.yCo+1][nN.xCo].myParent = nN;
					}

				}
				else if (nN.dist + calcDist(mapValue) <= cMove)
				{
					if (unitLocations[nN.yCo+1][nN.xCo] == null || getQualifiedSuperclassName(char) == getQualifiedSuperclassName(unitLocations[nN.yCo + 1][nN.xCo]))
					{
					node = new DijkNode(nN.dist + calcDist(mapValue),nN.xCo,nN.yCo + 1);
					node.myParent = nN;
					mapArray[nN.yCo + 1][nN.xCo] = node;
					openList.push(node);
					}
				}
			}
			closedList.push(openList[0]);
			openList.splice(0,1);


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
		private function testMap():void
		{
			for (var i:int=0; i<mapArray.length; i++)
			{
				for(var k:int=0; k<mapArray[i].length; k++)
				{
					if (mapArray[i][k] is DijkNode)
					{
						mapArray[i][k] = "N"
					}
				}
				trace(mapArray[i]);
			}
		}
		public function doExit():void
		{
			char = null;
			mapArray = null;
			origMap = null;
			node = null;
			closedList = null;
			openList = null;
		}

	}

}