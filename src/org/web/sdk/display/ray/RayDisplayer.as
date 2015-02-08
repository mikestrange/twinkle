package org.web.sdk.display.ray 
{
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.display.asset.SingleTexture;
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
	import org.web.sdk.utils.ClassUtils;
	
	import org.web.sdk.beyond_challenge;
	use namespace beyond_challenge
	/**
	 * 速度更快的显示对象，基于bitmapdata
	 */
	public class RayDisplayer extends Bitmap implements IAcceptor 
	{
		public static const AUTO:String = 'auto';	//所有Bitmap的默认方式
		//
		private var _texture:LibRender;
		
		public function RayDisplayer(texture:LibRender = null) 
		{
			super(null, AUTO, true);
			if (texture) setTexture(texture);
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
			if (_texture == texture) {
				if (_texture) {
					obtainMapped(_texture.render(this));
				}
			}else {
				if (_texture) _texture.relieve();
				_texture = texture;
				if (null == texture) return;
				obtainMapped(_texture.render(this));
			}
		}
		
		//获取必要的资源
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
				var texture:LibRender = factoryTexture(txName, tag);
				if (texture) this.setTexture(texture);
			}
		}
		
		//不一定设置名称给他自己,上面会设置
		protected function factoryTexture(textureName:String, tag:int = 0):LibRender
		{
			return null;
		}
		
		public function clone():IAcceptor 
		{
			return new RayDisplayer(_texture);
		}
		
		/* INTERFACE org.web.sdk.inters.IDisplayObject */
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
		
		public function removeFromFather():void
		{
			if (parent) parent.removeChild(this);
		}
		
		public function moveTo(mx:int = 0, my:int = 0):void 
		{
			this.x = mx;
			this.y = my;
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
		
		public function addUnder(father:IBaseSprite, mx:Number = 0, my:Number = 0, floor:int = -1):void
		{
			if (null == father) throw Error("参数为空");
			father.addDisplay(this, mx, my, floor);
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
		
		//static *****************************
		//快速渲染一个方行
		public static function createBySize(wide:int, heig:int, color:uint = 0):IAcceptor
		{
			var acceptor:IAcceptor = new RayDisplayer;
			var textureName:String = wide+"_" + heig + "_" + color + ":texture";
			if (LibRender.hasTexture(textureName)) {
				acceptor.setLiberty(textureName);
			}else {
				acceptor.setTexture(new SingleTexture(new BitmapData(wide, heig, false, color), textureName));
			}
			return acceptor;
		}
		//ends
	}
}