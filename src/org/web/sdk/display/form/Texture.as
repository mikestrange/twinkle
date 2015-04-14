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
		private var _frame:Rectangle;
		//
		private var _scalex:Number = 1;
		private var _scaley:Number = 1;
		
		public function Texture(bit:BitmapData, frame:Rectangle = null)
		{
			this._bit = bit;
			this._frame = frame == null ? new Rectangle() : frame;
			this.setSize(width, height);
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
			_frame.width = _bit.width;
			_frame.height = _bit.height;
			if (width != NONE) _frame.width = width;
			if (height != NONE) _frame.height = height;
			//scale
			_scalex = _frame.width / _bit.width;
			_scaley = _frame.height / _bit.height;
		}
		
		public function setPosition(x:int = 0, y:int = 0):void
		{
			_frame.x = x;
			_frame.y = y;
		}
		
		public function getImage():BitmapData
		{
			return _bit;
		}
		
		public function get x():int
		{
			return _frame.x;
		}
		
		public function get y():int
		{
			return _frame.y;
		}
		
		public function get width():int
		{
			return _frame.width;
		}
		
		public function get height():int
		{
			return _frame.height;
		}
		
		//调整注册点，这里需要固定在内部
		public function checkTrim(dis:DisplayObject):void
		{
			//dis.transform.matrix = new Matrix(_scalex, 0, 0, _scaley, _frame.x, _frame.y);
		}
		//ends
	}

}