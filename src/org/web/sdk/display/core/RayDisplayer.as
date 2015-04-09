package org.web.sdk.display.core 
{
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.display.asset.MapRender;
	import org.web.sdk.display.asset.AssetFactory;
	import org.web.sdk.display.asset.MotionRender;
	import org.web.sdk.display.asset.MovieRender;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.asset.BaseRender;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.display.utils.Swapper;
	import org.web.sdk.AppWork;
	import org.web.sdk.interfaces.IDisplay;
	import flash.geom.Transform;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import org.web.sdk.interfaces.IAcceptor;
	/**
	 * 速度更快的显示对象，基于bitmapdata
	 */
	public class RayDisplayer extends Bitmap implements IAcceptor 
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
		private var _isresize:Boolean = false;
		//渲染器
		private var _texture:LibRender;
		
		public function RayDisplayer(texture:LibRender = null) 
		{
			super(null, AUTO, true);
			if(texture) setTexture(texture);
		}
		
		/* INTERFACE org.web.sdk.interfaces.IAcceptor */
		public function dispose():void 
		{
			if (_texture) {
				_texture.relieve();
				this._texture = null;
			}
			this.bitmapData = null;
		}
		
		// 切换材质的时候，如果前一个是弱引用，那么就会被清理
		public function setTexture(texture:LibRender, data:Object = null):void 
		{
			if (_texture == texture) {
				flush(data);
			}else {
				if (_texture) _texture.relieve();
				_texture = texture;
				if (null == texture) return;
				renderBuffer(_texture.render(data));
			}
		}
		
		//刷新显示
		public function flush(data:Object = null):void
		{
			if (_texture) renderBuffer(_texture.createUpdate(data));
		}
		
		//获取必要的资源，子类重新就可以了
		protected function renderBuffer(assets:*):void
		{
			this.bitmapData = assets as BitmapData;
			this.smoothing = true;
		}
		
		//根据名称渲染材质,自由构造
		public function setLiberty(txName:String, data:Object = null, tag:int = -1):Boolean
		{
			if (null == txName || txName == "") throw Error("材质名称不允许为空");
			if (LibRender.hasTexture(txName)) {
				this.setTexture(LibRender.getTexture(txName), data);
				return true;
			}else {
				var tx:LibRender = factoryTexture(txName, tag);
				if (tx) this.setTexture(tx, data);
				return tx != null;
			}
			return false;
		}
		
		//不一定设置名称给他自己,上面会设置 ,默认是一个类名,你可以修改
		protected function factoryTexture(textureName:String, tag:int = 0):LibRender
		{
			switch(tag)
			{
				case BIT_TAG: 		return new BaseRender(textureName);
				case BUTTON_TAG: 	return new MapRender(textureName);
				case MOVIE_TAG: 	return new MovieRender(textureName);
				case MOTION_TAG:	return new MotionRender(textureName);
			}
			return null;
		}
		
		public function clone():IAcceptor 
		{
			return new RayDisplayer(_texture);
		}
		
		public function get texture():LibRender
		{
			return _texture;
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
		
		//static *****************************
		//快速渲染一个方行
		public static function createPixels(wide:int, heig:int, color:uint = 0):IAcceptor
		{
			var acceptor:IAcceptor = new RayDisplayer;
			var t_n:String = wide+"_" + heig + "_" + color + ":texture";
			if (LibRender.hasTexture(t_n)) {
				acceptor.setLiberty(t_n);
			}else {
				acceptor.setTexture(new BaseRender(t_n, new BitmapData(wide, heig, false, color)));
			}
			return acceptor;
		}
		
		//快速生成一种单一的材质
		public static function quick(className:String, father:IBaseSprite = null, floor:int = -1):RayDisplayer
		{
			var ray:RayDisplayer = new RayDisplayer;
			ray.setLiberty(className, null, RayDisplayer.BIT_TAG);
			ray.addUnder(father, floor);
			return ray;
		}
		
		//ends
	}
}