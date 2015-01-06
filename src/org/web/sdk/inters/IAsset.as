package org.web.sdk.inters 
{
	import flash.display.BitmapData;
	
	public interface IAsset 
	{
		function get resource():String;
		function set resource(value:String):void;
		//获取一个资源
		function derive(bit:BitmapData):void;			
		//ends
	}
	
}