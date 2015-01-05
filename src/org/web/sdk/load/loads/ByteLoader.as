package org.web.sdk.load.loads 
{
	import flash.net.URLLoaderDataFormat;
	
	public class ByteLoader extends TextLoader
	{
		override protected function getFormat():String 
		{
			return URLLoaderDataFormat.BINARY;
		}
		//ends
	}
}