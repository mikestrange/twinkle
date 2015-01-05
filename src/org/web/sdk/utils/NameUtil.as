package org.web.sdk.utils 
{
	import flash.utils.*;

	public class NameUtil 
	{
		
		public static function getClassName(value:*):String 
		{
			return getQualifiedClassName(value).replace("::", ".");
		}
		
		//ends
	}

}