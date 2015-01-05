package org.alg.utils 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import org.alg.astar.Grid;
	import org.alg.astar.Node;
	import org.alg.astar.NodeType;

	public class DrawLine 
	{
		
		//绘制矩形网格
		public static function drawGrid(wleng:int, hleng:int, width:int = 30, height:int = 30, color:uint = 0xff0000, thick:Number = 1):DisplayObject 
		{
			var shape:Shape = new Shape;
			shape.graphics.lineStyle(thick, color);
			var i:int = 0;
			for (i = 0; i < wleng; i++)
			{
				shape.graphics.moveTo(i * width, 0);
				shape.graphics.lineTo(i * width, hleng * height);
			}
			for (i = 0; i < hleng; i++)
			{
				shape.graphics.moveTo(0, i * height);
				shape.graphics.lineTo(wleng * width, i * height);
			}
			return shape;
		}
		
		//绘制一个起始骨架
		public static function drawSkeletonLine(width:Number = 100, height:Number = 100, line:uint = 2):DisplayObject
		{
			var shape:Sprite = new Sprite;
			shape.graphics.lineStyle(line, 0xff0000);
			shape.graphics.moveTo(-width/2, 0);
			shape.graphics.lineTo(width/2, 0);
			shape.graphics.moveTo(0, 0);
			shape.graphics.lineTo(0, -height);
			//shape.filters = [new GlowFilter(0, 1, 5, 5, 10, 3)];
			return shape;
		}
		
		//绘制一个矩形
		public static function drawRect(w:int, h:int, color:uint = 0):DisplayObject
		{
			var shape:Shape = new Shape;
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(0, 0, w, h);
			shape.graphics.endFill();
			return shape;
		}
		
		//根据网格绘制每一个区域
		//绘制地标
		public static function drawRectToNode(grid:Grid):DisplayObject
		{
			var node:Node;
			var shape:Shape = new Shape;
			for (var i:int = 0; i < grid.vertical; i++)
			{
				for (var j:int = 0; j < grid.across; j++)
				{
					node = grid.getNode(j, i);
					switch(node.type)
					{
						case NodeType.WALK:
							shape.graphics.beginFill(0, 0);
							shape.graphics.drawRect(j * grid.nodeWidth, i * grid.nodeHeight,grid.nodeWidth, grid.nodeHeight);
							break;
						case NodeType.NO_WALK:
							shape.graphics.beginFill(0x00000f, .5);
							shape.graphics.drawRect(j * grid.nodeWidth, i * grid.nodeHeight,grid.nodeWidth, grid.nodeHeight);
							break;
						case NodeType.MASK:
							shape.graphics.beginFill(0xff0000, .5);
							shape.graphics.drawRect(j * grid.nodeWidth, i * grid.nodeHeight, grid.nodeWidth, grid.nodeHeight);
							break;
					}
				}
			}
			return shape;
		}
		//ends
	}
}