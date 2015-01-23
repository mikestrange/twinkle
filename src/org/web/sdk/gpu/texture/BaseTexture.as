package org.web.sdk.gpu.texture 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import org.web.rpg.utils.MapPath;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.FrameWork;
	import org.web.sdk.gpu.Assets;
	import org.web.sdk.inters.IAcceptor;
	/**
	 * 材质  IAcceptor 这个接口才能调度
	 */
	public class BaseTexture
	{
		private var _bitmapdata:BitmapData;
		private var _name:String;
		private var _milde:Boolean;		//轻量的
		
		//不会自动释放 mild=false
		public function BaseTexture(bit:BitmapData, name:String = null, milde:Boolean = false) 
		{
			this._bitmapdata = bit;
			this._name = name;
			this._milde = milde;
		}
		
		public function setName(value:String):void
		{
			this._name = value;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get milde():Boolean
		{
			return _milde;
		}
		
		public function get texture():BitmapData
		{
			return _bitmapdata;
		}
		
		public function dispose():void {
			if (_bitmapdata && _bitmapdata.width && _bitmapdata.height) {
				_bitmapdata.dispose();
				_bitmapdata = null;
			}
		}
		
		//通过它去渲染,没有保存那么直接渲染
		public function render(mesh:IAcceptor):IAcceptor
		{
			if (_name == null || _name == "") {
				mesh.setTexture(this);
			}else {
				Assets.gets().mark(mesh, name);
			}
			return mesh;
		}
		
		//解除,如果没有保存在内存，如果是弱引用那么背解除后直接释放
		public function relieve():void
		{
			if (_name == null || _name == "") {
				if(_milde) dispose();
			}else {
				Assets.gets().unmark(_name);
			}
		}
		
		//----直接汇入
		public static function fromBitmapData(bitdata:BitmapData):BaseTexture
		{
			return new BaseTexture(bitdata);
		}
		
		//可以是displayer，movieclip,bitmapdata
		public static function fromClassName(className:String, url:String = null):BaseTexture
		{
			if (url == null) return fromLocalClassName(className);
			//ends
			var bit:BitmapData = FrameWork.getAsset(className, url);
			if (bit == null) return null;
			return fromBitmapData(bit);
		}
		
		//本地共享
		public static function fromLocalClassName(className:String):BaseTexture
		{
			var Objects:Class = getDefinitionByName(className) as Class;
			var item:* = new Objects(); //MovieClip不处理
			if (item == null) return null;
			if (item is DisplayObject) return fromBitmapData(Multiple.draw(item as DisplayObject));
			return fromBitmapData(item as BitmapData);
		}
		
		//根据一个泛型类，注入替换字符,不会被存入
		public static function fromVector(className:String, form:String, last:int = -1, url:String = null):Vector.<BaseTexture>
		{
			var vector:Vector.<BaseTexture> = new Vector.<BaseTexture>;
			var index:int = 1;	//0开始
			var name:String;
			var bitdata:BitmapData;
			while (true) {
				name = className.replace(form, index);
				bitdata = FrameWork.getAsset(name, url);
				if (null == bitdata) break;
				vector.push(fromBitmapData(bitdata));
				if (++index > last && last != -1) break;
			}
			return vector;
		}
		
		//ends
	}

}