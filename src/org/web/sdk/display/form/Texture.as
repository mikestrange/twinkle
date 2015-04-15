package org.web.sdk.display.form 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public class Texture 
	{
		private static const NONE:int = 0;
		//
		private var _bit:BitmapData;
		//x和y在帧动画中起作用
		private var _framex:Number;
		private var _framey:Number;
		private var _frameWidth:Number;
		private var _frameHeight:Number;
		//
		private var _width:Number;
		private var _height:Number;
		//
		private var _scalex:Number;
		private var _scaley:Number;
		
		public function Texture(bit:BitmapData, sizew:Object = null, sizeh:Object = null)
		{
			this._bit = bit;
			this.setSize(parseFloat(String(sizew)), parseFloat(String(sizeh)));
		}
		
		public function dispose():void
		{
			if (_bit && _bit.width > NONE && _bit.height > NONE) 
			{
				_bit.dispose();
				_bit = null;
			}
		}
		
		//尺寸
		public function setSize(width:Number, height:Number):void
		{
			if (!isNaN(width)) {
				_width = width;
				_scalex = _width / _bit.width;
			}
			if (!isNaN(height)) {
				_height = height;
				_scaley = _height / _bit.height;
			}
		}
		
		//帧的信息
		public function setFrameInfo(x:Number, y:Number, w:Number, h:Number):void
		{
			if (!isNaN(x)) _framex = x;
			if (!isNaN(y)) _framey = y;
			if (!isNaN(w)) _frameWidth = w;
			if (!isNaN(h)) _frameHeight = h;
		}
		
		public function getImage():BitmapData
		{
			return _bit;
		}
		
		public function get scaleX():int
		{
			return _scalex;
		}
		
		public function get scaleY():int
		{
			return _scaley;
		}
		
		//初始的时候可以调整位置
		public function checkTrim(dis:DisplayObject):void
		{
			
		}
		//ends
	}

}