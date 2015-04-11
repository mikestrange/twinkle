package org.web.sdk.display.game.map 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import org.web.sdk.display.core.SpriteTool;
	import org.web.sdk.AppWork;
	import org.web.sdk.global.string;
	import org.web.sdk.load.DownLoader;
	import org.web.sdk.load.LoadEvent;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 地图块
	 */
	public class MapItem extends Bitmap 
	{
		//区域
		private var _x:int;
		private var _y:int;
		private var _url:String;
		//是否进入开放列表中
		public var isOpen:Boolean;
		//是否下载
		private var _loader:DownLoader;
		
		public function MapItem(id:uint, mx:int = 0, my:int = 0, w:int = 0, h:int = 0)
		{
			this._x = mx;
			this._y = my;
			//设置位置
			this.x = _x * w;
			this.y = _y * h;
			//计算下载路径
			var dx:String = string.formatNumber(_x, 2);
			var dy:String = string.formatNumber(_y, 2);
			this._url = MapPath.getMapURL(id, "map_" + dy + "x" + dx);
		}
		
		public function get url():String 
		{
			return _url;
		}
		
		//下载
		public function startLoad():void
		{
			if (_loader == null) {
				_loader = new DownLoader;
				_loader.completeHandler = function(event:LoadEvent):void
				{
					if (event.isError) {
						_loader = null;
					}else {
						setTextures(event.bitmapdata);
					}
				}
				_loader.load(_url);
				_loader.start();
			}
		}
		
		//贴图
		public function setTextures(bitdata:BitmapData = null):void 
		{
			SpriteTool.dispose(this.bitmapData);
			if(bitdata) this.bitmapData = bitdata;
		}
		
		//设置容器
		public function setParent(father:DisplayObjectContainer = null):void
		{
			if (father) {
				if (parent == null) father.addChildAt(this, 0);
			}else {
				if (parent) parent.removeChild(this);
			}
		}
		
		//直接释放
		public function free():void 
		{
			if (_loader) {
				_loader.clean();
				_loader = null;
			}
			setTextures();
			setParent();
		}
		//ends
	}

}