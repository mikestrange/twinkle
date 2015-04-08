package org.web.rpg.core 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import org.web.rpg.utils.MapPath;
	import org.web.sdk.display.core.KitTool;
	import org.web.sdk.AppWork;
	import org.web.sdk.load.DownLoader;
	import org.web.sdk.load.LoadEvent;
	
	public class MapLump extends Bitmap
	{
		//连接地址
		private var _url:String;
		private var _x:int;
		private var _y:int;
		//是否进入开放列表中
		public var isOpen:Boolean = false;
		//是否下载
		private var _loader:DownLoader;
		
		public function MapLump(id:uint, mx:int = 0, my:int = 0, w:int = 0, h:int = 0)
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
			KitTool.dispose(this.bitmapData);
			this.bitmapData = bit;
		}
		
		public function startLoad():void
		{
			if (_loader == null) {
				_loader = new DownLoader;
				_loader.eventHandler = function(event:LoadEvent):void
				{
					if (event.isError) {
						_loader = null;
					}else {
						setBitmapdata(event.data as BitmapData);
					}
				}
				_loader.load(_url);
				_loader.start();
			}
		}
		
		public function show(target:DisplayObjectContainer):void 
		{
			if (parent == null) target.addChild(this);
		}
		
		public function hide():void
		{
			if (parent) parent.removeChild(this);
		}
		
		//直接释放
		public function free():void 
		{
			hide();
			if (_loader) {
				_loader.clean();
				_loader = null;
			}
			KitTool.dispose(this.bitmapData);
		}
		//ends
	}

}