package org.web.sdk.load.utils 
{
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 字节计算
	 */
	public class ByteUtils 
	{
		public static const KB:int = 1024;
		public static const MB:int = 1024 * 1024;
		public static const GB:int = 1024 * 1024 * 1024;
		
		public static function getKb(value:int):Number
		{
			return value / KB;
		}
		
		public static function getMb(value:int):Number
		{
			return value / MB;
		}
		
		public static function getGb(value:int):Number
		{
			return value / GB;
		}
		
		//end
	}

}