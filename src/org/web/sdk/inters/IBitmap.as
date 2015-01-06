package org.web.sdk.inters 
{
	import flash.display.BitmapData;
	
	public interface IBitmap extends IDisplayObject 
	{
		//释放
		function dispose():void;
		//设置材质
		function setTexture(byte:*, smooth:Boolean = true):void;	
		function clone():IBitmap;
		//ends
	}
}