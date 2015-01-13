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
		
		public function VRayTexture(bit:BitmapData, finWidth:int = 0, finHeight:int = 0) 
		{
			this._bitmapdata = bit;
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
		
		//---------
		public static function fromBitmapdata(bit:BitmapData):VRayTexture
		{
			return new VRayTexture(bit);
		}
		
		//可以是displayer，movieclip,bitmapdata
		public static function fromClass(className:String, app:ApplicationDomain = null):VRayTexture
		{
			if (app && app.hasDefinition(className)) {
				var Objects:Class = app.getDefinition(className) as Class;
				var item:* = new Objects;
				return new VRayTexture(item as BitmapData);
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