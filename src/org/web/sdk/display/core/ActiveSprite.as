package org.web.sdk.display.core 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.display.type.AlignType;
	import org.web.sdk.display.utils.Swapper;
	import org.web.sdk.inters.IDisplayObject;
	import flash.display.Sprite;
	import org.web.sdk.inters.IBaseSprite;
	/*
	 * 原始的，游戏中全部继承他
	 * */
	
	public class ActiveSprite extends Sprite implements IBaseSprite
	{
		private var _limitWidth:Number;
		private var _limitHeight:Number;
		private var _limitStamp:int;
		private var _offsetx:Number = 0;
		private var _offsety:Number = 0;
		private var _align:String = null;
		
		public function ActiveSprite()
		{
			initialization();
		}
		
		protected function initialization():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, showEvent, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, hideEvent, false, 0, true);
		}
		
		protected function showEvent(e:Object = null):void
		{
			
		}
		
		protected function hideEvent(e:Object = null):void
		{
			
		}
		
		
		/* INTERFACE org.web.sdk.inters.IBaseSprite */
		public function isEmpty():Boolean
		{
			return this.numChildren == 0;
		}
		
		public function getChildrenByOper(value:int = 0):Vector.<IDisplayObject>
		{
			if (isEmpty()) return null;
			const list:Vector.<IDisplayObject> = new Vector.<IDisplayObject>;
			var sun:IDisplayObject;
			for (var i:int = 0; i < numChildren; i++) {
				sun = this.getChildAt(i) as IDisplayObject;
				if (sun.getOper() == value) list.push(sun);
			}
			return list;
		}
		
		public function lockMouse(childs:Boolean = true):void
		{
			mouseEnabled = false;
			if (childs != mouseChildren) mouseChildren = childs;
		}
		
		public function unlockMouse(childs:Boolean = true):void
		{
			mouseEnabled = false;
			if (childs != mouseChildren) mouseChildren = childs;
		}
		
		public function removeByName(childName:String):IDisplayObject
		{
			var child:DisplayObject = this.getChildByName(childName);
			if (child) this.removeChild(child);
			return child as IDisplayObject;
		}
		
		public function clearChildren():void 
		{
			while (this.numChildren) removeChildAt(0);
		}
		
		public function addDisplay(child:IDisplayObject, floor:int = -1):Boolean
		{
			if (child && child.getFather() != this) {
				if (floor < 0 || numChildren < 1) {
					this.addChild(child as DisplayObject);
				}else {
					if (floor > numChildren - 1) floor = numChildren - 1;
					this.addChildAt(child as DisplayObject, floor);
				}
				child.reportFromFather(this);
				return true;
			}
			return false;
		}
		
		
		/* INTERFACE org.web.sdk.inters.IDisplayObject */
		public function toGlobal(mx:Number = 0, my:Number = 0):Point
		{
			return this.localToGlobal(new Point(mx, my));
		}
		
		public function toLocal(mx:Number = 0, my:Number = 0):Point
		{
			return this.globalToLocal(new Point(mx, my));
		}
		
		public function moveTo(mx:Number = 0, my:Number = 0):void
		{
			if (mx != x) this.x = mx;
			if (my != y) this.y = my;
		}
		
		public function setDisplayIndex(floor:int = -1):void 
		{
			if (parent) {
				if (parent.numChildren < 1) return;
				if (floor < 0) {
					parent.setChildIndex(this, parent.numChildren - 1);
				}else {
					if (floor > parent.numChildren - 1) floor = parent.numChildren - 1;
					parent.setChildIndex(this, floor);
				}
			}
		}
		
		public function reportFromFather(father:IBaseSprite):void 
		{
			if (_align == null) return;
			const swap:Swapper = AlignType.obtainReposition(limitWidth, limitHeight, 
			father.limitWidth, father.limitHeight, _align);
			this.x = swap.trimPositionX(_offsetx);
			this.y = swap.trimPositionY(_offsety);
		}
		
		public function clearFilters():void 
		{
			if (filters.length) {
				filters = [];
				filters = null;
			}
		}
		
		public function addUnder(father:IBaseSprite, floor:int = -1):Boolean 
		{
			if (father) {
				father.addDisplay(this, floor);
				return true;
			}
			return false;
		}
		
		public function frameRender(float:int = 0):void
		{
			
		}
		
		public function getFather():IBaseSprite
		{
			return this.parent as IBaseSprite;
		}
		
		public function isAdded():Boolean
		{
			return this.parent != null;
		}
		
		public function removeFromFather():void
		{
			if (parent) parent.removeChild(this);
		}
		
		public function setLimit(wide:Number = 0, heig:Number = 0):void 
		{
			_limitWidth = wide;
			_limitHeight = heig;
		}
		
		public function get limitWidth():Number 
		{
			if (isNaN(_limitWidth)) return this.width; 
			return _limitWidth;
		}
		
		public function get limitHeight():Number 
		{
			if (isNaN(_limitHeight)) return this.height; 
			return _limitHeight;
		}
		
		public function setAlign(align:String, offx:Number = 0, offy:Number = 0):void
		{
			_align = align;
			_offsetx = offx;
			_offsety = offy;
			if(isAdded()) reportFromFather(getFather());
		}
		
		public function get alignType():String 
		{
			return _align;
		}
		
		public function get offsetx():Number 
		{
			return _offsetx;
		}
		
		public function get offsety():Number 
		{
			return _offsety;
		}
		
		public function setOper(value:int):void 
		{
			_limitStamp = value;
		}
		
		public function getOper():int 
		{
			return _limitStamp;
		}
		
		public function resize():void
		{
			
		} 
		
		public function finality(value:Boolean = true):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, showEvent);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, hideEvent);
			this.clearFilters();
			Multiple.wipeout(this, value);
		}
		
		//设置子类的对齐格式   static
		public static function setDisplayAlign(dis:DisplayObject, align:String, offx:Number = 0, offy:Number = 0):void
		{
			if (null == dis) return;
			if (!dis.parent) return;
			var father:IBaseSprite = dis.parent as IBaseSprite;
			const swap:Swapper = AlignType.obtainReposition(dis.width, dis.height, father.limitWidth, father.limitHeight, align);
			dis.x = swap.trimPositionX(offx);
			dis.y = swap.trimPositionY(offy);
		}
		//end
	}

}