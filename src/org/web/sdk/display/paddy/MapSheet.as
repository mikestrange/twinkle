package org.web.sdk.display.paddy 
{
	import flash.events.Event;
	import flash.geom.Matrix;
	import org.web.sdk.AppWork;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.global.maths;
	import org.web.sdk.interfaces.IAlign;
	import org.web.sdk.interfaces.IDisplayObject;
	import org.web.sdk.interfaces.IBaseSprite;
	/**
	 * ...
	 * @author Main
	 */
	public class MapSheet extends Bitmap implements IDisplayObject ,IAlign
	{
		private static const LIM:int = 1;
		//属性
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _offsetx:Number = 0;
		private var _offsety:Number = 0;
		private var _finalPoint:Point = new Point;
		private var _align:String;
		private var _rototion:Number = 0;
		//
		private var _width:int;
		private var _height:int;
		private var _tag:uint;
		private var _isresize:Boolean;
		protected var _isrun:Boolean;
		
		public function MapSheet()
		{
			super(null, "auto", true);
		}
		
		public function dispose():void 
		{
			setRunning();
			setResize(false);
			this.bitmapData = null;
		}
		
		//获取必要的资源，子类重新就可以了
		public function setTexture(texture:Texture):void
		{
			this.bitmapData = texture.getImage();
			this.smoothing = true;
			this._updateAlign();
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
		
		public function moveTo(mx:Number = 0, my:Number = 0):void
		{
			this.x = mx;
			this.y = my;
		}
		
		public function setScale(sx:Number = 1, sy:Number = 1):void
		{
			this.scaleX = sx;
			this.scaleY = sy;
		}
		
		public function finality(value:Boolean = true):void
		{
			if (value) dispose();
		}
		
		public function setAlignOffset(alignType:String = null, offx:Number = 0, offy:Number = 0):void
		{
			_align = alignType;
			_offsetx = offx;
			_offsety = offy;
			_updateAlign();
		}
		
		public function get offsetx():Number
		{
			return _offsetx;
		}
		
		public function get offsety():Number
		{
			return _offsety;
		}
		
		public function get alignType():String
		{
			return _align;
		}
		
		//override
		override public function get x():Number 
		{
			return _x;
		}
		
		override public function set x(value:Number):void 
		{
			if (isNaN(value)) return;
			_x = value;
			if (_x + _finalPoint.x == super.x) return;
			super.x = _x + _finalPoint.x;
		}
		
		override public function get y():Number 
		{
			return _y;
		}
		
		override public function set y(value:Number):void 
		{
			if (isNaN(value)) return;
			_y = value;
			if (_y + _finalPoint.y == super.y) return;
			super.y = _y + _finalPoint.y;
		}
		
		//这里不计算缩放的偏移，固定偏移,校正的会计算缩放
		protected function _updateAlign():void
		{
			if (_align) {
				_finalPoint = AlignType.getSelfAlign(this, _align);
				_finalPoint.offset(offsetx, offsety);
			}else {
				_finalPoint = new Point(offsetx, offsety);
			}
			this.x = _x;
			this.y = _y;
		}
		
		//
		override public function set scaleX(value:Number):void 
		{
			if (isNaN(value) || value == this.scaleX) return;
			super.scaleX = value;
			_updateAlign();
		}
		
		override public function set scaleY(value:Number):void 
		{
			if (isNaN(value) || value == this.scaleY) return;
			super.scaleY = value;
			_updateAlign();
		}
		
		//注册点旋转方式
		public function set offsetRotation(value:Number):void
		{
			const offset_matrix:Matrix = this.transform.matrix;
			offset_matrix.translate( -_x, -_y);
			offset_matrix.rotate((value - offsetRotation) * Math.PI / 180);
			offset_matrix.translate(_x, _y);
			this.transform.matrix = offset_matrix;
			trace(this.x, this.y, this._finalPoint);
		}
		
		public function get offsetRotation():Number
		{
			return this.rotation;
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