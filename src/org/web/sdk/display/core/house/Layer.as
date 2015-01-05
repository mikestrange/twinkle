package org.web.sdk.display.core.house 
{
	import flash.display.DisplayObject;
	import org.web.sdk.display.core.BoneSprite;
	import org.web.sdk.display.inters.ILayer;
	
	public class Layer extends BoneSprite implements ILayer 
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
			return removeChild(dis);
		}
		
		//不需要释放元件下面的东西
		public function removeAll():void
		{
			while(numChildren) removeChildAt(0);
		}
		
		override public function drawBack(mx:Number = 0, my:Number = 0, across:Number = 0, vertical:Number = 0, color:uint = 0):void 
		{
			this.backAlpha = .4;
			super.drawBack(mx, my, across, vertical, 0x222222);
		}
		
		//ends
	}
}