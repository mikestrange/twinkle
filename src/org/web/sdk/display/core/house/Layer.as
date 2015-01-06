package org.web.sdk.display.core.house 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import org.web.sdk.display.core.house.ILayer;
	import org.web.sdk.display.core.KitSprite;
	
	public class Layer extends KitSprite implements ILayer 
	{
		public function Layer(vsname:String, value:Boolean = false) 
		{
			this.name = vsname;
			this.mouseEnabled = value;
		}
		
		/* INTERFACE org.web.sdk.display.inters.ILayer */
		public function addToLayer(dis:DisplayObject):DisplayObject
		{
			return addChild(dis);
		}
		
		public function removeToLayer(dis:DisplayObject):DisplayObject
		{
			removeChild(dis);
			return dis;
		}
		//ends
	}
}