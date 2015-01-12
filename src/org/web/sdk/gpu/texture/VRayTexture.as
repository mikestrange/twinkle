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
		
		public static function fromAppdomain(className:String, app:ApplicationDomain = null):VRayTexture
		{
			if (app && app.hasDefinition(className)) {
				var classs:Class = app.getDefinition(className) as Class;
				return new VRayTexture(new classs);
			}
			return null;
		}
		
		public static function fromVector(className:String, form:String, last:int = -1, url:String = null):Vector.<VRayTexture>
		{
			var vector:Vector.<VRayTexture> = new Vector.<VRayTexture>;
			var index:int = 1;	//0开始
			var name:String;
			var bit:BitmapData;
			while (true) {
				name = className.replace(form, index);
				trace(name,url)
				bit = FrameWork.getAsset(name, url);
				trace(bit)
				// fromAppdomain(className.replace(form, index), FrameWork.app.getAppDomain(url));
				if (null == bit) break;
				vector.push(fromBitmapdata(bit));
				if (++index > last && last != -1) break;
			}
			return vector;
		}
		
		//ends
	}

}