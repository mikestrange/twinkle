package org.alg.utils 
{
	import org.alg.astar.Grid;
	
	public class ConvertMesh 
	{
		//一维 转换 grid y↓  x→
		public static function onlyLong(arr:Array, across:int, vertical:int, nodew:int = 30, nodeh:int = 30):Grid
		{
			var grid:Grid = new Grid(nodew, nodeh);
			grid.across = across;
			grid.vertical = vertical;
			var index:int = -1;
			for (var i:int = 0; i < grid.vertical; i++)
			{
				for (var j:int = 0; j < grid.across; j++)
				{
					grid.addNode(j, i, arr[++index]);
					//trace("y=",i,",x=" , j,",type=", arr[index]);
				}
			}
			return grid;
		}
		
		//二维 转换 grid  y↓  x→
		public static function doubleLong(arr:Array, nodew:int = 30, nodeh:int = 30):Grid
		{
			var grid:Grid = new Grid(nodew, nodeh);
			grid.across = arr[0].length;
			grid.vertical = arr.length;
			for (var i:int = 0; i < grid.vertical; i++)
			{
				for (var j:int = 0; j < grid.across; j++)
				{
					grid.addNode(j, i, arr[i][j]);
					//trace("y=",i,",x=" , j,",type=", arr[i][j]);
				}
			}
			return grid;
		}
		
		//ends
	}

}