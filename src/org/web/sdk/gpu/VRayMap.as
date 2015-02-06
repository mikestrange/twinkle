package org.web.sdk.gpu 
{
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.gpu.texture.BaseTexture;
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
	
	/**
	 * 贴图基类,自身释放了bitmapdata，扩展不必调用dispose
	 */
	public class VRayMap extends Bitmap implements IAcceptor 
	{
		public static const AUTO:String = 'auto';	//所有Bitmap的默认方式
		//
		private var _texture:BaseTexture;
		
		public function VRayMap(texture:BaseTexture = null) 
		{
			super(null, AUTO, true);
			if (texture) {
				if (texture.isHamper()) {
					texture.render(this);
				}else {
					setTexture(texture);
				}
			}
		}
		
		/* INTERFACE org.web.sdk.inters.IAcceptor */
		public function dispose():void 
		{
			if (_texture) _texture.relieve();
			this._texture = null;
			this.bitmapData = null;
		}
		
		// 切换材质的时候，如果前一个是弱引用，那么就会被清理
		public function setTexture(texture:BaseTexture):void 
		{
			if (texture == null) throw Error("材质无效"); 	//一旦材质命名，就会被解除的时候被释放
			if (_texture == texture) return;
			if (_texture) _texture.relieve();
			_texture = texture;
			this.bitmapData = _texture.texture;
			this.smoothing = true;
		}
		
		//根据名称渲染材质,自由构造
		public function setLiberty(textureName:String, tag:int = 0):void
		{
			if (null == textureName || textureName == "") throw Error("材质名称不允许为空");
			if (Assets.asset.has(textureName)) {
				Assets.asset.mark(this, textureName);
			}else {
				var texture:BaseTexture = factoryTexture(textureName, tag);
				if (texture) {
					texture.setName(textureName);
					texture.render(this);
				}
			}
		}
		
		//不一定设置名称给他自己,上面会设置
		protected function factoryTexture(textureName:String, tag:int = 0):BaseTexture
		{
			return null;
		}
		
		public function clone():IAcceptor 
		{
			return new VRayMap(_texture);
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
		//自定义渲染
		public static function createBySize(wide:int, heig:int, color:uint = 0):IAcceptor
		{
			var acceptor:IAcceptor = new VRayMap;
			var textureName:String = wide+"_" + heig + "_" + color + ":texture";
			if (Assets.asset.has(textureName)) {
				acceptor.setLiberty(textureName);
			}else {
				var texture:BaseTexture = BaseTexture.fromBitmapData(new BitmapData(wide, heig, false, color));
				texture.setName(textureName);
				texture.render(acceptor);
			}
			return acceptor;
		}
		//ends
	}
}