package org.web.sdk.display.form.atlas 
{
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 截取材质信息
	 */
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class TextureInfo
	{
		private static const POINT:Point = new Point;
		public var region:Rectangle;	//截取的区域
		public var frame:Rectangle;		//帧位置
		public var rotated:Boolean;		//是否复用
		
		public function TextureInfo(region:Rectangle, frame:Rectangle, rotated:Boolean)
		{
			this.region = region;
			this.frame = frame;
			this.rotated = rotated;       
		}
		
		public function getX(firstx:int):int
		{
			return firstx - frame.x;
		}
		
		public function getY(firsty:int):int
		{
			return firsty - frame.y;
		}
		
		//切割原图
		public function draw(res:BitmapData):BitmapData
		{
			var bit:BitmapData = new BitmapData(region.width, region.height, true, 0);
			bit.copyPixels(res, region, POINT);
			return bit;
		}
		//ends
	}
}