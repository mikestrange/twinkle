package org.web.sdk.inters 
{
	import flash.display.BitmapData;
	import org.web.sdk.gpu.texture.VRayTexture;
	
	public interface IAcceptor extends IDisplayObject 
	{
		//释放
		function dispose():void;
		function setTexture(texture:VRayTexture):void;	
		function clone():IAcceptor;
		//ends
	}
}