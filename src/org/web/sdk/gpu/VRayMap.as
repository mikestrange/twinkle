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
		protected static const asset:Assets = Assets.gets();
		
		private var _texture:BaseTexture;
		
		public function VRayMap(texture:BaseTexture = null) 
		{
			super(null, AUTO, true);
			if (texture) setTexture(texture);
		}
		
		/* INTERFACE org.web.sdk.inters.IAcceptor */
		public function get resource():String
		{
			return null;
		}
		
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
			if (_texture != texture && _texture) _texture.relieve();
			_texture = texture;
			this.bitmapData = texture.texture;
			this.smoothing = true;
		}
		
		public function clone():IAcceptor 
		{
			return new VRayMap(this._texture);
		}
		
		/* INTERFACE org.web.sdk.inters.IDisplayObject */
		public function showEvent(event:Event = null):void 
		{
			
		}
		
		public function hideEvent(event:Event = null):void 
		{
			
		}
		
		public function clearFilters():void 
		{
			if (filters.length) {
				filters = [];
				filters = null;
			}
		}
		
		public function getMouse():Point 
		{
			return new Point(mouseX, mouseY);
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
		
		public function follow(dis:IDisplayObject, ofx:Number = 0, ofy:Number = 0, global:Boolean = false):void 
		{
			if (global) {
				var p:Point = dis.localToGlobal(new Point);
				moveTo(p.x + ofx, p.y + ofy);
			}else {
				moveTo(dis.x + ofx, dis.y + ofy);
			}
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
		
		public function addInto(father:IBaseSprite, mx:Number = 0, my:Number = 0, floor:int = -1):void
		{
			if (father) father.addDisplay(this, mx, my, floor);
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
		//这里直接渲染出材质
		public static function createByName(textureName:String, url:String = null):IAcceptor
		{
			var acceptor:IAcceptor = new VRayMap;
			if (asset.has(textureName)) {
				asset.mark(acceptor, textureName);
			}else {
				asset.mark(acceptor, textureName, BaseTexture.fromClassName(textureName, url));
			}
			return acceptor;
		}
		
		//自定义渲染
		public static function createBySize(wide:int, heig:int, color:uint = 0):IAcceptor
		{
			var acceptor:IAcceptor = new VRayMap;
			var textureName:String = wide+"_" + heig + "_" + color + ":texture";
			if (asset.has(textureName)) {
				asset.mark(acceptor, textureName);
			}else {
				var bit:BitmapData = new BitmapData(wide, heig, false, color);
				asset.mark(acceptor, textureName, BaseTexture.fromBitmapData(bit));
			}
			return acceptor;
		}
		
		//直接  默认移除就会被释放
		public static function createByBitmapdata(bitmap:BitmapData, milde:Boolean = true):IAcceptor
		{
			return new VRayMap(new BaseTexture(bitmap, null, milde));
		}
		
		public static function createByUrl(url:String):IAcceptor
		{
			return new BufferImage(url);
		}
		
		//ends
	}
}