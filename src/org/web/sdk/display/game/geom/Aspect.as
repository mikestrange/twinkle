package org.web.sdk.display.game.geom 
{
	public class Aspect 
	{
		private var min:int;
		private var max:int;
		public var type:int;
		
		public function Aspect(min:int,max:int,type:int) 
		{
			this.min = min;
			this.max = max;
			this.type = type;
		}
			
		public function inThis(point:int):Boolean
		{
			return point > min && point < max;
		}
		
		public function unThis(point:int):Boolean
		{
			return point < min || point > max;
		}	
		//ends
	}
}