package org.web.sdk.inters 
{
	import flash.display.BitmapData;
	import org.web.sdk.gpu.texture.BaseTexture;
	
	public interface IAcceptor extends IDisplayObject 
	{
		function get resource():String;
		function setTexture(texture:BaseTexture):void;	
		function dispose():void;
		function clone():IAcceptor;
		//ends
	}
}