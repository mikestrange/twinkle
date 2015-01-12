package org.web.sdk.inters 
{
	import flash.display.BitmapData;
	import org.web.sdk.gpu.texture.VRayTexture;
	import org.web.sdk.load.LoadEvent;
	
	public interface IBuffer 
	{
		function get resource():String;
		function complete(e:LoadEvent):void;
		function setTexture(texture:VRayTexture):void;
		//ends
	}
	
}