package org.web.sdk.display.inters 
{
	import flash.display.DisplayObject;
	
	//也就是说,图层不能被添加到其他地方，只能添加到
	public interface ILayer extends ISprite
	{
		function addToLayer(dis:DisplayObject):DisplayObject;
		function removeToLayer(dis:DisplayObject):DisplayObject;
		function removeAll():void;
		//ends
	}
}