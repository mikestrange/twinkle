package org.web.sdk.display.inters 
{
	import flash.display.BitmapData;
	
	public interface IBitmap 
	{
		function closed():void
		function dispose():void;
		function clone():IBitmap;
		function setBitmapdata(bitmapdata:BitmapData, smooth:Boolean = true):void;
	}
}