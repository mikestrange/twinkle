package org.web.sdk.display 
{
	import flash.display.DisplayObject;
	
	//也就是说,图层不能被添加到其他地方，只能添加到
	public interface ILayer
	{
		function addToLayer(dis:DisplayObject):DisplayObject;
		function removeToLayer(dis:DisplayObject):DisplayObject;
		function isEmpty():Boolean;
		function removeFromFather():void;
		//ends
	}
}