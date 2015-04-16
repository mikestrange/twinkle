package org.web.sdk.display.paddy.template 
{
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 截取材质信息
	 */
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.web.sdk.AppWork;
	import flash.display.BitmapData;
	import org.web.sdk.display.paddy.Texture;

	public class TextureInfo
	{
		private static const POINT:Point = new Point;
		//截取的区域   swf中无用
		public var region:Rectangle;	
		//帧位置
		public var frame:Rectangle;		
		//是否复用
		public var rotated:Boolean;		
		//帧位置
		private var _framex:Number;
		private var _framey:Number;
		
		public function TextureInfo(region:Rectangle, frame:Rectangle, rotated:Boolean = false)
		{
			this.region = region;
			this.frame = frame;
			this.rotated = rotated;   
			if (frame) {
				_framex = frame.x;
				_framey = frame.y;
			}
		}
		
		//这里通过资源的swf获得
		public function getTexture(name:String, url:String):Texture
		{
			return new Texture(AppWork.getAsset(name, url) as BitmapData);
		}
		
		//切割原图
		public function drawTexture(res:BitmapData):Texture
		{
			var bit:BitmapData = new BitmapData(region.width, region.height, true, 0);
			bit.copyPixels(res, region, POINT);
			return new Texture(bit);
		}
		//ends
	}
}