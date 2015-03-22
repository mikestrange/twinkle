package org.web.sdk.display.utils 
{
	public class Swapper 
	{
		private var _x:Number;
		private var _y:Number;
		private var _tx:Number = 1;
		private var _ty:Number = 1;
		
		public function Swapper(x:Number = 0, y:Number = 0) 
		{
			_x = x;
			_y = y;
		}
		
		public function set x(value:Number):void
		{
			_x = value;
		}
		
		public function set y(value:Number):void
		{
			_y = value;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function setTrend(x:Number = 1, y:Number = 1):void
		{
			_tx = x;
			_ty = y;
		}
		
		//最终转换 x
		public function trimPositionX(x:Number):Number
		{
			return _x + x * _tx;
		}
		
		//最终转换 y
		public function trimPositionY(y:Number):Number
		{
			return _y + y * _ty;
		}
		//end
	}

}