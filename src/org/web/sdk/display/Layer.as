package org.web.sdk.display 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import org.web.sdk.display.core.ActiveSprite;
	import org.web.sdk.display.ILayer;
	import org.web.sdk.inters.IDisplay;
	
	public class Layer extends ActiveSprite implements ILayer 
	{
		public function Layer(layerName:String, value:Boolean = false) 
		{
			this.name = layerName;
			this.mouseEnabled = value;
		}
		
		/* INTERFACE org.web.sdk.display.inters.ILayer */
		public function addToLayer(dis:DisplayObject):DisplayObject
		{
			this.addDisplay(dis as IDisplay);
			return dis;
		}
		
		public function removeToLayer(dis:DisplayObject):DisplayObject
		{
			return removeChild(dis);
		}
		
		//ends
	}
}