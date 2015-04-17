package org.web.sdk.display.game.geom 
{
	/*
	 * 一个方向范围值
	 * */
	public class Region 
	{
		private var min:int;
		private var max:int;
		public var type:int;
		
		public function Region(min:int, max:int, type:int) 
		{
			this.min = min;
			this.max = max;
			this.type = type;
		}
			
		public function inThis(point:Number):Boolean
		{
			return point > min && point < max;
		}
		
		public function unThis(point:Number):Boolean
		{
			return point < min || point > max;
		}	
		
		public function toString():String
		{
			return "{ min=" + min + ", max=" + max +", type=" + type + "}";
		}
		//ends TaxReckon
	}
}