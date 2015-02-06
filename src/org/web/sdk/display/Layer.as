package org.web.sdk.display 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import org.web.sdk.display.ILayer;
	import org.web.sdk.display.RawSprite;
	
	public class Layer extends RawSprite implements ILayer 
	{
		public function Layer(layerName:String, value:Boolean = false) 
		{
			this.name = layerName;
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
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
			throw Error("Layer不允许注册事件");
		}
		//ends
	}
}