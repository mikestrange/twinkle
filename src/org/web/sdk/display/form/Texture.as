package org.web.sdk.display.form 
{
	import flash.display.BitmapData;
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
			_frame.width = width == NONE ? _bit.width : width;
			_frame.height = height == NONE ? _bit.height : height;
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
		
		//ends
	}

}