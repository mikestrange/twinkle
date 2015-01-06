package org.web.sdk.inters 
{
	import flash.display.BitmapData;
	
	public interface IBitmap extends IDisplayObject 
	{
		function dispose():void;
		function setTexture(byte:*, smooth:Boolean = true):void;
		function clone():IBitmap;
		//ends
	}
}