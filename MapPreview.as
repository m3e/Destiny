package 
{

	import flash.display.Sprite;
	import flash.events.Event;
	public class MapPreview extends Sprite
	{

		private var tileSide:int;
		private var tileList:Array;

		public function MapPreview()
		{
			tileSide = 32;
			
			// constructor code
			addEventListener(Event.REMOVED_FROM_STAGE, removed,false,0,true);
		}
		private function removed(e:Event):void
		{
			for (var i:int=0; i < tileList.lenght; i++)
			{
				for (var o:int=0; o < tileList[i].length; o++)
				{
					if (tileList[i][o] is Trees)
					{
						removeChild(tileList[i][o].backgroundTile);
						tileList[i][o].backgroundTile = null;
					}
					removeChild(tileList[i][o]);
				}
			}
			tileList = null;
		}
		public function viewMap(mapArray:Array):void
		{
			tileList = new Array;
			for (var i:int = 0; i < mapArray.length; i++)
			{
				tileList.push(new Array);
				for (var u:int = 0; u < mapArray[i].length; u++)
				{
					tileList[i].push(null);
					var gr:grass;
					if (mapArray[i][u] == 0 || mapArray[i][u] == 6)
					{
						gr = new grass(u,i);
						gr.x = tileSide * u;
						gr.y = tileSide * i;
						addChild(gr)
						tileList[i][u] = gr;
						if (mapArray[i][u] == 6)
						{
							var tr:Trees = new Trees(u,i);
							tr.backgroundTile = tileList[i][u];
							tr.x = tileSide * u;
							tr.y = tileSide * i;
							addChild(tr);
							tileList[i][u] = tr;
						}
					}
					else if (mapArray[i][u] == 1)
					{
						var st:Stone = new Stone(u,i);
						st.x = tileSide * u;
						st.y = tileSide * i;
						addChild(st)
						tileList[i][u] = st;
					}
					else if (mapArray[i][u] == 2)
					{
						var mt:Mountain = new Mountain(u,i);
						mt.x = tileSide * u;
						mt.y = tileSide * i;
						addChild(mt)
						tileList[i][u] = mt;
					}
					else if (mapArray[i][u] == 3)
					{
						var cto:CastleTower = new CastleTower(u,i);
						cto.x = tileSide * u;
						cto.y = tileSide * i;
						addChild(cto)
						tileList[i][u] = cto;
					}
					else if (mapArray[i][u] == 4)
					{
						var dt:Dirt = new Dirt(u,i);
						dt.x = tileSide * u;
						dt.y = tileSide * i;
						addChild(dt)
						tileList[i][u] = dt;
					}
				}
			}
		}

	}

}