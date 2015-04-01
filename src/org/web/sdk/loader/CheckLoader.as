package org.web.sdk.loader 
{
	import flash.utils.Dictionary;
	import org.web.sdk.loader.interfaces.ILoader;
	import org.web.sdk.loader.interfaces.ILoadRequest;
	
	public class CheckLoader 
	{
		public static var maxLength:int = 1;
		//
		private static var _urls:Vector.<ILoadRequest> = new Vector.<ILoadRequest>;
		private static var _map:Dictionary = new Dictionary;
		private static var _loadMap:Dictionary = new Dictionary;
		private static var _currentIndex:int = 0; 
		private static var _isset:Boolean = false;
		
		//同一个URL只会保存一个
		internal static function putStack(request:ILoadRequest, loader:DownLoader, prior:Boolean = false):void
		{
			//设置默认
			if (!_isset) {
				_isset = !_isset;
				LoadSetup.setDefault();
			}
			var url:String = request.url;	
			var list:Vector.<DownLoader> = _map[url];
			if (list == null) {
				list = new Vector.<DownLoader>;
				_map[url] = list;
				if (prior) {
					_urls.unshift(request);
				}else {
					_urls.push(request);
				}
			}
			list.push(loader);
		}
		
		internal static function startLoad():void
		{
			if (isEmpty()) return;
			if (_currentIndex >= maxLength) return;
			var request:ILoadRequest = _urls.shift();
			var url:String = request.url;
			if (isHave(url)) 
			{
				var loader:ILoader = LoadSetup.createLoader(LoadSetup.getUrlType(url));
				_loadMap[url] = loader;
				loader.download(request);
				_currentIndex++;
			}
			startLoad();
		}
		
		private static function isHave(url:String):Boolean
		{
			return _map[url] != undefined;
		}
		
		private static function isEmpty():Boolean
		{
			return _urls.length == 0;
		}
		
		//派发事件
		public static function dispatchs(url:String, type:String, data:*= undefined):void 
		{
			var event:LoadEvent = new LoadEvent(type, url, data);
			var list:Vector.<DownLoader> = _map[url];
			//这里先删除
			if (event.isOver) removeLoaders(url);
			//列表遍历
			if (list) {
				for each(var loader:DownLoader in list) {
					loader.eventResult(event);
				}
			}
			//处理了数据，继续下载
			if (event.isOver) reduceAndStart();
		}
		
		//关闭一个下载器的下载
		internal static function removeLoader(url:String, loader:DownLoader):void
		{
			var list:Vector.<DownLoader> = _map[url];
			if (list) {
				var index:int = list.indexOf(loader);
				if (index != -1) {
					list.splice(index, 1);
					if (list.length == 0) {
						delete _map[url];
						closeLoader(url);
					}
				}
			}
		}
		
		//唯一公开的方法
		//清理所有下载
		public static function cleanAll():void
		{
			if (_urls.length) {
				_urls = new Vector.<ILoadRequest>;
			}
			var key:String = null;
			var load:ILoader = null;
			var loader:DownLoader = null;
			//清理所有下载管理
			for (key in _map) {
				loader = _map[key];
				delete _map[key];
				loader.clean();
			}
			_map = new Dictionary;
			//关闭所有下载
			for (key in _loadMap) {
				load = _loadMap[key];
				delete _loadMap[key];
				load.destroy();
			}
			_loadMap = new Dictionary;
			_currentIndex = 0;
		}
		
		private static function removeLoaders(url:String):void
		{
			if (isHave(url)) delete _map[url];
			if(_loadMap[url]) delete _loadMap[url];
		}
		
		private static function closeLoader(url:String):void
		{
			var load:ILoader = _loadMap[url];
			if (load) {
				delete _loadMap[url];
				load.destroy();
				//并且关闭下载，开始下载下一个
				reduceAndStart();
			}
		}
		
		private static function reduceAndStart():void
		{
			--_currentIndex;
			startLoad();
		}
		//end
	}

}