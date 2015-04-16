package org.web.sdk.display.core 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.display.utils.Swapper;
	import org.web.sdk.AppWork;
	import org.web.sdk.interfaces.IDisplay;
	import flash.display.Sprite;
	import org.web.sdk.interfaces.IBaseSprite;
	/*
	 * 原始的，游戏中全部继承他
	 * */
	public class BaseSprite extends Sprite implements IBaseSprite
	{
		private var _tag:int;
		private var _width:int;
		private var _height:int;
		//状态
		protected var _isresize:Boolean;
		protected var _isrun:Boolean;
		//防止事件问题 , adobe写的东西确实有问题
		private var avert_show:Boolean;
		
		public function BaseSprite()
		{
			initialization();
		}
		
		protected function initialization():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, showListener, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, hideListener, false, 0, true);
		}
		
		private function showListener(event:Event):void
		{
			if (avert_show) return;
			avert_show = !avert_show;
			showEvent();
		}
		
		private function hideListener(event:Event):void
		{
			if (avert_show) {
				avert_show = !avert_show;
				hideEvent();
			}
		}
		
		//这里只会又一次处理
		protected function showEvent():void
		{
			
		}
		
		protected function hideEvent():void
		{
			setResize(false);
			setRunning(false);
		}
		
		/* INTERFACE org.web.sdk.interfaces.IBaseSprite */
		public function isEmpty():Boolean
		{
			return this.numChildren == 0;
		}
		
		public function convertSprite():Sprite
		{
			return this;
		}
		
		public function getName():String
		{
			return this.name;
		}
		
		//取所有孩子
		public function getChildren(tag:int = -1):Array
		{
			if (isEmpty()) return null;
			const list:Array = new Array;
			var dis:DisplayObject;
			for (var i:int = 0; i < numChildren; i++) {
				dis = this.getChildAt(i);
				if (tag >= 0 && dis is IDisplay)
				{
					if (IDisplay(dis).getTag() == tag) {
						list.push(dis);
					}
				}else {
					list.push(dis);
				}
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
		
		public function removeByName(childName:String):IDisplay
		{
			var child:DisplayObject = this.getChildByName(childName);
			if (child) this.removeChild(child);
			return child as IDisplay;
		}
		
		public function clearChildren():void 
		{
			while (this.numChildren) removeChildAt(0);
		}
		
		public function addDisplay(child:IDisplay, floor:int = -1):Boolean
		{
			if (child && child.getFather() != this) {
				if (floor < 0 || numChildren < 1) {
					super.addChild(child as DisplayObject);
				}else {
					if (floor > numChildren - 1) floor = numChildren - 1;
					super.addChildAt(child as DisplayObject, floor);
				}
				return true;
			}
			return false;
		}
		
		
		/* INTERFACE org.web.sdk.interfaces.IDisplayObject */
		public function toGlobal(mx:Number = 0, my:Number = 0):Point
		{
			return this.localToGlobal(new Point(mx, my));
		}
		
		public function toLocal(mx:Number = 0, my:Number = 0):Point
		{
			return this.globalToLocal(new Point(mx, my));
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
		
		public function setSize(wide:int, high:int):void
		{
			_width = wide;
			_height = high;
		}
		
		public function get sizeWidth():int
		{
			if (_width == 0) return width;
			return _width;
		}
		
		public function get sizeHeight():int
		{
			if (_height == 0) return height;
			return _height;
		}
		
		public function getFather():IBaseSprite
		{
			return this.parent as IBaseSprite;
		}
		
		public function isAdded():Boolean
		{
			return this.parent != null;
		}
		
		public function removeFromFather(value:Boolean = false):void
		{
			if (parent) parent.removeChild(this);
			if (value) finality();
		}
		
		public function moveTo(mx:Number = 0, my:Number = 0):void
		{
			if (!isNaN(mx) && this.x != mx) this.x = mx;
			if (!isNaN(my) && this.y != my) this.y = my;
		}
		
		public function setScale(sx:Number = 1, sy:Number = 1):void
		{
			if (!isNaN(sx) && sx != scaleX) scaleX = sx;
			if (!isNaN(sy) && sy != scaleY) scaleY = sy;
		}
		
		public function setTag(value:uint):void 
		{
			_tag = value;
		}
		
		public function getTag():uint 
		{
			return _tag;
		}
		
		public function setResize(value:Boolean = true):void
		{
			if (_isresize == value) return;
			_isresize = value;
			if (value) {
				AppWork.addStageListener(Event.RESIZE, onResize);
			}else {
				AppWork.removeStageListener(Event.RESIZE, onResize);
			}
		}
		
		public function setRunning(value:Boolean = false):void
		{
			if (_isrun == value) return;
			_isrun = value;
			if (value) {
				AppWork.addStageListener(Event.ENTER_FRAME, runEnter);
			}else {
				AppWork.removeStageListener(Event.ENTER_FRAME, runEnter);
			}
		}
		
		protected function runEnter(event:Event = null):void
		{
			
		}
		
		protected function onResize(event:Event = null):void
		{
			
		}
		
		public function convertDisplay():DisplayObject
		{
			return this as DisplayObject;
		}
		
		public function finality(value:Boolean = true):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, showListener);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, hideListener);
			this.clearFilters();
			SpriteTool.wipeout(this, value);
		}
		//end
	}

}