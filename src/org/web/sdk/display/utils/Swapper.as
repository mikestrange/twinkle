package org.web.sdk.display.utils 
{
	public class Swapper 
	{
		private var _x:Number;
		private var _y:Number;
		private var _tx:Number = 1;
		private var _ty:Number = 1;
		
		public function Swapper(x:Number = 0, y:Number = 0, tx:int = 1, ty:int = 1) 
		{
			_x = x;
			_y = y;
			_tx = tx;
			_ty = ty;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		//最终转换 x
		public function trimx(offx:Number):Number
		{
			return _x + offx * _tx;
		}
		
		//最终转换 y
		public function trimy(offy:Number):Number
		{
			return _y + offy * _ty;
		}
		//end
	}

}