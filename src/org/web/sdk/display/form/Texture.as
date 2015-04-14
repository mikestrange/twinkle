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
		private var _framex:int;
		private var _framey:int;
		private var _frameWidth:int;
		private var _frameHeight:int;
		//
		private var _scalex:Number = 1;
		private var _scaley:Number = 1;
		
		public function Texture(bit:BitmapData, x:int = 0, y:int = 0, w:int = 0, h:int = 0)
		{
			this._bit = bit;
			this.setPosition(x, y);
			this.setSize(w, h);
		}
		
		public function dispose():void
		{
			if (_bit && _bit.width > 0 && _bit.height > 0) 
			{
				_bit.dispose();
				_bit = null;
			}
		}
		
		public function setSize(width:int = 0, height:int = 0):void
		{
			_frameWidth = _bit.width;
			_frameHeight = _bit.height;
			if (width != NONE) _frameWidth = width;
			if (height != NONE) _frameHeight = height;
			//scale
			_scalex = _frameWidth / _bit.width;
			_scaley = _frameHeight / _bit.height;
		}
		
		public function setPosition(x:int = 0, y:int = 0):void
		{
			_framex = x;
			_framey = y;
		}
		
		public function getImage():BitmapData
		{
			return _bit;
		}
		
		public function get x():int
		{
			return _framex;
		}
		
		public function get y():int
		{
			return _framey;
		}
		
		public function get width():int
		{
			return _frameWidth;
		}
		
		public function get height():int
		{
			return _frameHeight;
		}
		
		//调整注册点，这里需要固定在内部
		public function checkTrim(dis:DisplayObject):void
		{
			//dis.transform.matrix = new Matrix(_scalex, 0, 0, _scaley, _frame.x, _frame.y);
		}
		//ends
	}

}