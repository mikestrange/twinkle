package org.web.sdk.display.form 
{
	import flash.events.Event;
	import org.web.sdk.AppWork;
	import org.web.sdk.interfaces.IBaseSprite;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import org.web.sdk.interfaces.IDisplay;
	
	/**
	 * ...
	 * @author Main
	 */
	public class BaseSheet extends Bitmap implements IDisplay 
	{
		//属性
		private var _width:int;
		private var _height:int;
		private var _tag:uint;
		private var _isresize:Boolean;
		protected var _isrun:Boolean;
		
		public function BaseSheet()
		{
			super(null, "auto", true);
		}
		
		public function dispose():void 
		{
			this.bitmapData = null;
		}
		
		//获取必要的资源，子类重新就可以了
		public function setTexture(texture:Texture):void
		{
			this.bitmapData = texture.getImage();
			this.smoothing = true;
			//texture.checkTrim(this);
		}
		
		/* INTERFACE org.web.sdk.interfaces.IDisplay */
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
			if (this.x != mx) this.x = mx;
			if (this.y != my) this.y = my;
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
		
		public function removeFromFather(value:Boolean = false):void
		{
			if (parent) parent.removeChild(this);
			if (value) this.finality();
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
		
		public function convertDisplay():DisplayObject
		{
			return this as DisplayObject;
		}
		
		public function setScale(sx:Number = 1, sy:Number = 1):void
		{
			if (sx != scaleX) scaleX = sx;
			if (sy != scaleY) scaleY = sy;
		}
		
		public function finality(value:Boolean = true):void
		{
			if (value) dispose();
		}
		
		//protected
		protected function runEnter(e:Event = null):void
		{
			
		}
		
		protected function onResize(e:Event = null):void
		{
			
		}
		
		//ends
	}

}