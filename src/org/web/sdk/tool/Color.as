package org.web.sdk.tool 
{
	public class Color 
	{
		public var a:int;
		public var r:int;
		public var g:int;
		public var b:int;
		
		public function Color(r:int = 0, g:int = 0, b:int = 0, a:int = 0)
		{
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}
		
		public function argb():uint
		{
			return a << 24 | r << 16 | g << 8 | b;
		}
		
		public function rgb():uint
		{
			return r << 16 | g << 8 | b;
		}
		
		//
		public static function getColor(value:uint):Color
		{
			return new Color(value >> 16 & 0xff, value >> 8 & 0xff, value & 0xff, value >> 24 & 0xff);
		}
		
		//
	}

}