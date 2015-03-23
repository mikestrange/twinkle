package org.web.sdk.display.core 
{
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.display.asset.SingleTexture;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.display.utils.Swapper;
	import org.web.sdk.FrameWork;
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
	import org.web.sdk.load.PerfectLoader;
	import org.web.sdk.utils.ClassUtils;
	
	import org.web.sdk.beyond_challenge;
	use namespace beyond_challenge
	/**
	 * 速度更快的显示对象，基于bitmapdata
	 */
	public class RayDisplayer extends Bitmap implements IAcceptor 
	{
		//格式
		public static const AUTO:String = 'auto';	//所有Bitmap的默认方式
		//属性
		private var _limitWidth:Number;
		private var _limitHeight:Number;
		private var _limitStamp:int;
		private var _offsetx:Number = 0;
		private var _offsety:Number = 0;
		private var _align:String = null;
		//渲染器
		private var _texture:LibRender;
		//自身放置一个下载器吧
		protected static const loader:PerfectLoader = PerfectLoader.gets();
		
		public function RayDisplayer(texture:* = null) 
		{
			super(null, AUTO, true);
			if (texture is String) {
				setLiberty(texture as String);
			}else if (texture is LibRender) {
				setTexture(texture);
			}
		}
		
		/* INTERFACE org.web.sdk.inters.IAcceptor */
		public function dispose():void 
		{
			if (_texture) {
				_texture.relieve();
				this._texture = null;
			}
			this.bitmapData = null;
		}
		
		// 切换材质的时候，如果前一个是弱引用，那么就会被清理
		public function setTexture(texture:LibRender):void 
		{
			if (_texture && _texture == texture) {
				obtainMapped(_texture.update(this));
			}else {
				if (_texture) _texture.relieve();
				_texture = texture;
				if (null == texture) return;
				obtainMapped(_texture.render(this));
			}
		}
		
		//获取必要的资源，子类重新就可以了
		protected function obtainMapped(assets:*):void
		{
			this.bitmapData = assets as BitmapData;
			this.smoothing = true;
		}
		
		//根据名称渲染材质,自由构造
		public function setLiberty(txName:String, tag:int = 0):void
		{
			if (null == txName || txName == "") throw Error("材质名称不允许为空");
			if (LibRender.hasTexture(txName)) {
				this.setTexture(LibRender.getTexture(txName));
			}else {
				var tx:LibRender = factoryTexture(txName, tag);
				if (tx) this.setTexture(tx);
			}
		}
		
		//不一定设置名称给他自己,上面会设置 ,默认是一个类名,你可以修改
		protected function factoryTexture(textureName:String, tag:int = 0):LibRender
		{
			return FrameWork.getTexture(textureName);
		}
		
		public function clone():IAcceptor 
		{
			var ray:RayDisplayer = new RayDisplayer(_texture);
			Multiple.initNaturo(ray);
			return ray;
		}
		
		public function get texture():LibRender
		{
			return _texture;
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
			if (isNaN(_limitWidth) || _limitWidth == 0) return this.width; 
			return _limitWidth;
		}
		
		public function get limitHeight():Number 
		{
			if (isNaN(_limitHeight) || _limitHeight == 0) return this.height; 
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
				acceptor.setTexture(new SingleTexture(new BitmapData(wide, heig, false, color), t_n));
			}
			return acceptor;
		}
		//ends
	}
}