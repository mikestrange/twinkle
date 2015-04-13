package org.web.sdk.display.form 
{
	import flash.events.Event;
	import org.web.sdk.display.form.ActionMethod;
	import org.web.sdk.display.form.interfaces.IRender;
	import org.web.sdk.display.form.lib.AnimationRender;
	import org.web.sdk.display.form.lib.MediaRender;
	import org.web.sdk.display.form.lib.ClassRender;
	import org.web.sdk.interfaces.IDisplay;
	import org.web.sdk.display.form.lib.ResRender;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.display.utils.Swapper;
	import org.web.sdk.AppWork;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import org.web.sdk.interfaces.IAcceptor;
	/**
	 * 速度更快的显示对象，基于bitmapdata
	 */
	public class RayObject extends Bitmap implements IRender
	{
		//
		public static const BIT_TAG:int = 0;
		public static const BUTTON_TAG:int = 1;
		public static const MOVIE_TAG:int = 2;
		public static const MOTION_TAG:int = 3;
		//格式
		public static const AUTO:String = 'auto';	//所有Bitmap的默认方式
		//属性
		private var _limitWidth:Number;
		private var _limitHeight:Number;
		private var _limitStamp:int;
		private var _offsetx:Number = 0;
		private var _offsety:Number = 0;
		private var _align:String = null;
		private var _isresize:Boolean;
		protected var _isrun:Boolean;
		//渲染器
		private var _res:ResRender;
		
		public function RayObject(res:ResRender = null) 
		{
			super(null, AUTO, true);
			if(res) getBufferRender(res);
		}
		
		/* INTERFACE org.web.sdk.interfaces.IRender */
		public function dispose():void 
		{
			cleanRender();
			if (_res) {
				_res.relieve();
				this._res = null;
			}
		}
		
		// 切换材质的时候，如果前一个是弱引用，那么就会被清理
		final public function getBufferRender(res:ResRender, action:ActionMethod = null):void
		{
			if (_res == res) {
				updateBuffer(action);
			}else {
				if (_res) _res.relieve();
				_res = res;
				if (_res) {
					_res.additional();
					_res.setPowerfulRender(this, action);
				}
			}
		}
		
		//刷新显示
		public function updateBuffer(action:ActionMethod = null):void
		{
			if (_res) _res.setPowerfulRender(this, action);
		}
		
		//获取必要的资源，子类重新就可以了
		public function setTexture(texture:Texture):void
		{
			this.bitmapData = texture.getImage();
			this.smoothing = true;
		}
		
		public function cleanRender():void
		{
			if(this.bitmapData) this.bitmapData = null;
		}
		
		//根据名称渲染材质,自由构造
		public function setLiberty(txName:String, tag:int = -1, data:ActionMethod = null):Boolean
		{
			if (null == txName || txName == "") throw Error("材质名称不允许为空");
			if (ResRender.asset.has(txName)) {
				this.getBufferRender(ResRender.asset.getTexture(txName), data);
				return true;
			}else {
				var asset:ResRender = factoryTexture(txName, tag);
				if (asset) this.getBufferRender(asset, data);
				return asset != null;
			}
			return false;
		}
		
		//不一定设置名称给他自己,上面会设置 ,默认是一个类名,你可以修改
		protected function factoryTexture(txname:String, tag:int):ResRender
		{
			switch(tag)
			{
				case BIT_TAG: 		return new ClassRender(txname);
				case BUTTON_TAG: 	return new AnimationRender(txname);
				case MOVIE_TAG: 	return new MediaRender(txname);
			}
			return null;
		}
		
		public function clone():IRender 
		{
			return new RayObject(_res);
		}
		
		final public function getRes():ResRender
		{
			return _res;
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
		
		public function removeFromFather(value:Boolean = false):void
		{
			if (parent) parent.removeChild(this);
			if (value) this.finality();
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
		
		protected function runEnter(e:Event = null):void
		{
			
		}
		
		protected function onResize(e:Event = null):void
		{
			
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
		
		//ends
	}
}