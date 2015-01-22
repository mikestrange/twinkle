package org.web.sdk.display 
{
	import flash.events.Event;
	import flash.geom.Transform;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.inters.IDisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import org.web.sdk.inters.IBaseSprite;
	
	public class KitSprite extends Sprite implements IBaseSprite 
	{
		
		/* INTERFACE org.web.sdk.inters.IBaseSprite */
		public function lock():void 
		{
			this.mouseEnabled = false;
		}
		
		public function unlock():void 
		{
			this.mouseEnabled = true;
		}
		
		public function removeChildByName(disName:String):DisplayObject 
		{
			var dis:DisplayObject = getChildByName(disName);
			if (dis) removeChild(dis);
			return dis;
		}
		
		public function addDisplay(dis:IDisplayObject, mx:Number = NaN, my:Number = NaN):void 
		{
			if (!isNaN(mx)) dis.x = mx;
			if (!isNaN(my)) dis.y = my;
			this.addChild(dis as DisplayObject);
		}
		
		public function isByName(disName:String):Boolean 
		{
			return getChildByName(disName) != null;
		}
		
		public function clearChildren():void 
		{
			while (this.numChildren) removeChildAt(0);
		}
		
		public function addChildByName(child:IDisplayObject, sonName:String = null, index:int = -1):IDisplayObject 
		{
			if (sonName != null) {
				if (getChildByName(sonName) == child) throw Error('命名重复->' + sonName);
				child.name = sonName;
			}
			if (numChildren < 1 || index <= 0||index >= numChildren) return addChild(child as DisplayObject) as IDisplayObject;
			//
			return addChildAt(child as DisplayObject, index) as IDisplayObject;
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
			return parent as IBaseSprite;
		}
		
		public function initialization(value:Boolean = true):void 
		{
			
		}
		
		public function isshow():Boolean 
		{
			return parent != null;
		}
		
		public function show():void 
		{
			
		}
		
		public function hide():void 
		{
			if (parent) parent.removeChild(this);
		}
		
		public function showEvent(event:Event = null):void 
		{
			
		}
		
		public function hideEvent(event:Event = null):void 
		{
			
		}
		
		public function render():void 
		{
			
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
		
		public function isEmpty():Boolean 
		{
			return numChildren == 0;
		}
		
		public function finality(value:Boolean = true):void 
		{
			clearFilters();
			this.graphics.clear();
			Multiple.wipeout(this, value);
		}
		
		public function removeFromParent():IBaseSprite
		{
			var father:IBaseSprite = getParent();
			if (parent) parent.removeChild(this);
			finality();
			return father;
		}
		
		public function setAuto(type:String = null):void 
		{
			
		}
		
		public function addInto(father:IBaseSprite, mx:Number = 0, my:Number = 0):void
		{
			if (father) {
				father.addChildByName(this);
				this.moveTo(mx, my);
			}
		}
		
		public function onResize(target:Object = null):void 
		{
			
		}
		//ends
	}

}