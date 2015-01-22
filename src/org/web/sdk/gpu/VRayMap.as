package org.web.sdk.gpu 
{
	import flash.events.Event;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.gpu.texture.VRayTexture;
	import org.web.sdk.inters.IDisplayObject;
	import flash.geom.Transform;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import org.web.sdk.inters.IBaseSprite;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import org.web.sdk.inters.IAcceptor;
	
	/**
	 * 贴图基类
	 */
	public class VRayMap extends Bitmap implements IAcceptor 
	{
		public static const AUTO:String = 'auto';	//所有Bitmap的默认方式
		
		public function VRayMap(texture:VRayTexture = null) 
		{
			super(null, AUTO, true);
			if(texture) setTexture(texture);
		}
		
		/* INTERFACE org.web.sdk.inters.IBitmap */
		public function dispose():void 
		{
			Multiple.dispose(this.bitmapData);
			this.bitmapData = null;
		}
		 
		public function setTexture(texture:VRayTexture):void 
		{
			if (texture == null) throw Error("材质无效"); 
			this.bitmapData = texture.texture;
			this.smoothing = true;
		}
		
		public function clone():IAcceptor 
		{
			return null;
		}
		
		public function clearFilters():void 
		{
			if (filters.length) {
				filters = [];
				filters = null;
			}
		}
		
		public function getMouse():Point 
		{
			return new Point(mouseX, mouseY);
		}
		
		public function getParent():IBaseSprite 
		{
			return parent as IBaseSprite
		}
		
		public function removeFromParent():IBaseSprite
		{
			var father:IBaseSprite = getParent();
			if (parent) parent.removeChild(this);
			return father;
		}
		
		public function moveTo(mx:int = 0, my:int = 0):void 
		{
			this.x = mx;
			this.y = my;
		}
		
		public function moveToPoint(value:Point):void 
		{
			this.x = value.x;
			this.y = value.y;
		}
		
		public function follow(dis:IDisplayObject, ofx:Number = 0, ofy:Number = 0, global:Boolean = false):void 
		{
			if (global) {
				moveToPoint(dis.localToGlobal(new Point(ofx, ofy)));
			}else {
				moveTo(dis.x + ofx, dis.y + ofy);
			}
		}
		
		public function setNorms(horizontal:Number = 1, vertical:Number = 1, ratio:Boolean = true):void 
		{
			if (ratio) {
				this.scaleX = horizontal;
				this.scaleY = vertical;
			}else {
				this.width = horizontal;
				this.height = vertical;
			}
		}
		
		public function addInto(father:IBaseSprite, mx:Number = 0, my:Number = 0):void
		{
			if (father) father.addDisplay(this, mx, my);
		}
		
		public function render():void 
		{
			
		}
		
		public function setAuto(type:String = null):void 
		{
			
		}
		
		public function isshow():Boolean 
		{
			return parent != null;
		}
		//ends
	}
}