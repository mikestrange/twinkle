package org.web.sdk.display.core.scale 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ScaleRect 
	{
		private static const point:Point = new Point;
		public var rect:Rectangle;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		public var bitdata:BitmapData;
		
		public function ScaleRect(res:BitmapData, tx:int, ty:int, wide:int, heig:int) 
		{
			copy(res, tx, ty, wide, heig);
		}
		
		//拷贝原图
		public function copy(res:BitmapData, tx:int, ty:int, wide:int, heig:int):void
		{
			rect = new Rectangle(tx, ty, wide, heig);
			bitdata = new BitmapData(rect.width, rect.height, true, 0);
			bitdata.copyPixels(res, rect, point);
			this.x = tx;
			this.y = ty;
			this.width = rect.width;
			this.height = rect.height;
		}
		
		public function draw(bit:BitmapData):void
		{
			const matrix:Matrix = new Matrix(width / rect.width, 0, 0, height / rect.height, x, y);
			const chiprect:Rectangle = new Rectangle(x, y, width, height);
			bit.draw(bitdata, matrix, null, null, chiprect);
			bitdata.dispose();
		}
		//end
	}

}