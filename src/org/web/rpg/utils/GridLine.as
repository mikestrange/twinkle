package org.web.rpg.utils 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.web.rpg.astar.Grid;
	import org.web.rpg.astar.Node;
	import org.web.rpg.astar.NodeType;
	
	public class GridLine 
	{
		//绘制矩形网格 只是网格
		public static function drawGrid(graphics:Graphics, wleng:int, hleng:int, width:int = 30, height:int = 30, color:uint = 0xff0000, thick:Number = 1):void
		{
			graphics.clear();
			graphics.lineStyle(thick, color);
			var i:int = 0;
			for (i = 0; i < wleng; i++)
			{
				graphics.moveTo(i * width, 0);
				graphics.lineTo(i * width, hleng * height);
			}
			for (i = 0; i < hleng; i++)
			{
				graphics.moveTo(0, i * height);
				graphics.lineTo(wleng * width, i * height);
			}
		}
		
		//绘制一个起始骨架
		public static function drawSkeletonLine(graphics:Graphics, width:Number = 50, height:Number = 100, line:uint = 2):void
		{
			graphics.clear();
			graphics.lineStyle(line, 0xff0000);
			graphics.moveTo( -width / 2, 0);
			graphics.lineTo(width / 2, 0);
			graphics.moveTo(0, 0);
			graphics.lineTo(0, -height);
		}
		
		//根据网格绘制每一个区域
		//绘制地标
		public static function drawRectToNode(grid:Grid, graphics:Graphics):void
		{
			var node:Node;
			graphics.clear();
			for (var i:int = 0; i < grid.vertical; i++)
			{
				for (var j:int = 0; j < grid.across; j++)
				{
					node = grid.getNode(j, i);
					switch(node.type)
					{
						case NodeType.WALK:
								graphics.beginFill(0, 0);
								graphics.drawRect(j * grid.nodeWidth, i * grid.nodeHeight,grid.nodeWidth, grid.nodeHeight);
							break;
						case NodeType.NO_WALK:
								graphics.beginFill(0x00000f, .5);
								graphics.drawRect(j * grid.nodeWidth, i * grid.nodeHeight,grid.nodeWidth, grid.nodeHeight);
							break;
						case NodeType.MASK:
								graphics.beginFill(0xff0000, .5);
								graphics.drawRect(j * grid.nodeWidth, i * grid.nodeHeight, grid.nodeWidth, grid.nodeHeight);
							break;
					}
				}
			}
		}
		//ends
	}
}