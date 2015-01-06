package org.alg.map 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import org.alg.utils.MapPath;
	import org.web.sdk.display.core.VRayMap;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;

	public class NodeTexture extends VRayMap
	{
		//连接地址
		private var _url:String;
		private var _x:int;
		private var _y:int;
		//是否进入开放列表中
		public var isOpen:Boolean = false;
		//是否下载
		private var _isLoad:Boolean = false;

		public function NodeTexture(id:uint, mx:int = 0, my:int = 0, w:int = 0, h:int = 0)
		{
			this._x = mx;
			this._y = my;
			var dx:String = _x > 9 ? String(_x) : "0" + _x;
			var dy:String = _y > 9 ? String(_y) : "0" + _y;
			this._url = MapPath.getMapURL(id, "map_" + dy + "x" + dx);
			//位置
			this.x = _x * w;
			this.y = _y * h;
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		public function setBitmapdata(bit:BitmapData):void 
		{
			super.setTexture(null);
			super.setTexture(bit, true);
		}
		
		public function startLoad():void
		{
			if (_isLoad) return;
			_isLoad = true;
			PerfectLoader.gets().addWait(_url, LoadEvent.IMG, null).addRespond("map+", complete);
		}
		
		private function complete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) {
				_isLoad = false;
				return;
			}
			setBitmapdata(e.target as BitmapData);
		}
		
		public function show(target:DisplayObjectContainer):void 
		{
			if (parent == null) {
				target.addChild(this);
			}
		}
		
		public function hide():void
		{
			if (parent) parent.removeChild(this);
		}
		
		//直接释放
		public function free():void 
		{
			_isLoad = false;
			PerfectLoader.gets().removeMark(_url, "map+");
			hide();
			super.dispose();
		}
		//ends
	}

}