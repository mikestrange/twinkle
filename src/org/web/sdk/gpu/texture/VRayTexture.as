package org.web.sdk.gpu.texture 
{
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import org.web.sdk.FrameWork;
	import org.web.sdk.inters.IAcceptor;
	/**
	 * 材质
	 */
	public class VRayTexture
	{
		private var _bitmapdata:BitmapData;
		private var _mild:Boolean;
		
		//不会自动释放 mild=false
		public function VRayTexture(bit:BitmapData, mild:Boolean = false) 
		{
			this._bitmapdata = bit;
			this._mild = mild;
		}
		
		public function set mild(value:Boolean):void
		{
			_mild = value;
		}
		
		//微弱的
		public function get mild():Boolean
		{
			return _mild;
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
		
		public function render(mesh:IAcceptor):void
		{
			mesh.setTexture(this);
		}
		
		//解除
		public function relieve():void
		{
			if(_mild) dispose();
		}
		
		//---------
		public static function fromBitmapdata(bit:BitmapData, mild:Boolean = false):VRayTexture
		{
			return new VRayTexture(bit, mild);
		}
		
		//可以是displayer，movieclip,bitmapdata
		public static function fromClass(className:String, app:ApplicationDomain = null, mild:Boolean = false):VRayTexture
		{
			if (app && app.hasDefinition(className)) {
				var Objects:Class = app.getDefinition(className) as Class;
				var item:* = new Objects;
				return new VRayTexture(item as BitmapData, mild);
			}
			return null;
		}
		
		//根据一个泛型类，注入替换字符
		public static function fromVector(className:String, form:String, last:int = -1, url:String = null):Vector.<VRayTexture>
		{
			var vector:Vector.<VRayTexture> = new Vector.<VRayTexture>;
			var index:int = 1;	//0开始
			var name:String;
			var bitdata:BitmapData;
			while (true) {
				name = className.replace(form, index);
				bitdata = FrameWork.getAsset(name, url);
				if (null == bitdata) break;
				vector.push(fromBitmapdata(bitdata));
				if (++index > last && last != -1) break;
			}
			return vector;
		}
		
		//ends
	}

}