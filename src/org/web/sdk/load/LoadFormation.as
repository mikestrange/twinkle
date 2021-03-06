package org.web.sdk.load 
{
	import flash.utils.Dictionary;
	import org.web.sdk.load.interfaces.ILoader;
	import org.web.sdk.load.interfaces.ILoadRequest;
	import org.web.sdk.log.Log;
	
	public class LoadFormation 
	{
		/*
		 * 下载主目录
		 * */
		
		private static const NONE:int = 0;
		/*
		 * 设置最多下载
		 * */
		public static var maxLength:int = 1;
		/*
		 * 缓冲列表
		 * */
		private static var _urls:Array = new Array;
		/*
		 * 快速缓冲区
		 * */
		private static var _preMap:Dictionary = new Dictionary;
		/*
		 * 真正下载
		 * */
		private static var _loadMap:Dictionary = new Dictionary;
		/*
		 * 当前下载个数
		 * */
		private static var _currentIndex:int = 0; 			
		/*
		 * 是否初始化下载器
		 * */
		private static var _isset:Boolean = false;		
		
		private static function setup():void
		{
			if (!_isset) {
				_isset = !_isset;
				LoadSetup.setDefault();
			}
		}
		
		//同一个URL只会保存一个
		internal static function putStack(request:ILoadRequest, loader:DownLoader):void
		{
			//设置默认
			setup();
			//
			var url:String = request.url;	
			var vector:Vector.<DownLoader> = _preMap[url];
			if (vector == null) {
				vector = new Vector.<DownLoader>;
				_preMap[url] = vector;
				_urls.push(request);
				//目前不进行排序
			}
			vector.push(loader);
		}
		
		//手动排序
		public static function loadSort():void
		{
			_urls.sortOn("priority", Array.DESCENDING | Array.NUMERIC);
		}
		
		internal static function startLoad():void
		{
			if (isEmpty()) return;
			if (_currentIndex >= maxLength) return;
			var request:ILoadRequest = _urls.shift();
			var url:String = request.url;
			//如果你的request.type没有自己定义，那么就会自动识别下载
			if (isHave(url)) 
			{
				var type:Number =  parseInt(request.type);
				if (isNaN(type)) type = LoadSetup.getUrlType(url);
				var loader:ILoader = LoadSetup.createLoader(type);
				Log.log().debug("##开始下载:", request.loadUrl);
				_loadMap[url] = loader;
				loader.download(request);
				_currentIndex++;
			}
			startLoad();
		}
		
		private static function isHave(url:String):Boolean
		{
			return _preMap[url] != undefined;
		}
		
		private static function isEmpty():Boolean
		{
			return _urls.length == NONE;
		}
		
		//派发事件
		public static function dispatchs(url:String, type:String, data:*= undefined):void 
		{
			var event:LoadEvent = new LoadEvent(type, url, data);
			var list:Vector.<DownLoader> = _preMap[url];
			//这里先删除
			if (event.isOver) {
				Log.log().debug("##下载完成:", url, type);
				removeLoaders(url);
			}
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
			var list:Vector.<DownLoader> = _preMap[url];
			if (list) {
				var index:int = list.indexOf(loader);
				if (index != -1) {
					list.splice(index, 1);
					if (list.length == NONE) {
						Log.log().debug("##关闭下载:", url);
						delete _preMap[url];
						closeLoader(url);
					}
				}
			}
		}
		
		private static function removeLoaders(url:String):void
		{
			if (isHave(url)) delete _preMap[url];
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
		
		//唯一公开的方法*******清理所有下载********
		public static function cleanAll():void
		{
			Log.log().debug("##清理下载器");
			if (_urls.length) _urls = new Array;// new Vector.<ILoadRequest>;
			//
			var key:String = null;
			//清理所有下载管理
			var list:Vector.<DownLoader> = null;
			for (key in _preMap) {
				list = _preMap[key];
				delete _preMap[key];
				while (list.length) {
					list.shift().clean();
				}
			}
			//_preMap = new Dictionary;
			//关闭所有下载
			var loader:ILoader = null;
			for (key in _loadMap) {
				loader = _loadMap[key];
				delete _loadMap[key];
				loader.destroy();
			}
			//_loadMap = new Dictionary;
			_currentIndex = NONE;
		}
		//end
	}

}