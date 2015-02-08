package org.web.sdk.display 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.inters.IDisplayObject;
	import flash.display.Sprite;
	import org.web.sdk.inters.IBaseSprite;
	/*
	 * 原始的，游戏中全部继承他
	 * */
	public class RawSprite extends Sprite implements IBaseSprite 
	{
		/* INTERFACE org.web.sdk.inters.IBaseSprite */
		public function lock(child:Boolean = true):void 
		{
			this.mouseEnabled = false;
			if (child != this.mouseChildren) this.mouseChildren = child;
		}
		
		public function unlock(child:Boolean = true):void 
		{
			this.mouseEnabled = true;
			if (child != this.mouseChildren) this.mouseChildren = child;
		}
		
		public function addDisplay(dis:IDisplayObject, mx:Number = 0, my:Number = 0, floor:int = -1):void 
		{
			dis.moveTo(mx, my);
			if (floor < 0 || floor > this.numChildren) floor = this.numChildren;
			this.addChildAt(dis as DisplayObject, floor);
		}
		
		public function clearChildren():void 
		{
			while (this.numChildren) removeChildAt(0);
		}
		
		public function clearFilters():void 
		{
			if (filters.length) {
				filters = [];
				filters = null;
			}
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
		
		//自己会释放
		public function removeFromFather():void
		{
			if (parent) parent.removeChild(this);
		}
		
		public function setAuto(type:String = null):void 
		{
			
		}
		
		public function removeByName(disName:String):DisplayObject
		{
			var dis:DisplayObject = this.getChildByName(disName);
			if (dis) this.removeChild(dis);
			return dis;
		}
		
		public function addUnder(father:IBaseSprite, mx:Number = 0, my:Number = 0, floor:int = -1):void
		{
			if (father) father.addDisplay(this, mx, my, floor);
		}
		
		public function onResize(target:Object = null):void 
		{
			
		}
		//ends
	}

}