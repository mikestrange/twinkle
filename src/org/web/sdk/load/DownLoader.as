package org.web.sdk.load 
{
	import flash.utils.Dictionary;
	import org.web.sdk.load.interfaces.ILoadRequest;
	/*
	 * 很好用的一个下载器
	 * ##唯一要注意的是： 最好不要用单列，因为回调只有一个
	 * */
	public class DownLoader 
	{
		private static const NONE:int = 0;
		//回调函数
		private var _apply:Function;
		//是否省略下载过程
		private var _iselide:Boolean;
		//观察表
		private var _loadMap:Dictionary;
		//未完成列表
		private var _length:int;
		
		public function DownLoader(elide:Boolean = true, called:Function = null)
		{
			_iselide = elide;
			_apply = called;
		}
		
		//固定下载
		public function load(url:String, context:*= undefined, version:String = null, prior:Boolean = false):ILoadRequest
		{
			var request:ILoadRequest = new LoadRequest(url, version, context);
			loadRequest(request, prior);
			return request;
		}
		
		//一个下载器不重复添加同名下载，控制版本和请求地址是不一样的
		public function loadRequest(request:ILoadRequest, prior:Boolean = false):ILoadRequest
		{
			if (isHave(request.url)) return request;
			if (null == _loadMap) _loadMap = new Dictionary;
			_loadMap[request.url] = request;
			++_length;
			CheckLoader.putStack(request, this, prior);
			return request;
		}
		
		//开始下载
		public function start():void
		{
			CheckLoader.startLoad();
		}
		
		public function maxLength(value:int = 1):void
		{
			CheckLoader.maxLength = value;
		}
		
		//回调
		public function set eventHandler(value:Function):void
		{
			_apply = value;
		}
		
		//这里下载器提供回调，就算结束也不会清理下载队列
		internal function eventResult(event:LoadEvent):void
		{
			if (_iselide && !event.isOver) return;
			//本地删除
			if (event.isOver) remove(event.url);
			//回调
			if (_apply is Function) _apply(event);
		}
		
		public function isHave(path:String):Boolean
		{
			if (null == _loadMap) return false;
			return _loadMap[path] != undefined;
		}
		
		public function get length():int
		{
			return _length;
		}
		
		public function get empty():Boolean
		{
			return _length == NONE;
		}
		
		//移除一个下载
		public function remove(path:String):void 
		{
			if (isHave(path)) 
			{
				--_length;
				delete _loadMap[path];
				if (_length == NONE) _loadMap = null;
				CheckLoader.removeLoader(path, this);
			}
		}
		
		//清理自身的下载
		public function clean():void
		{
			if (_loadMap) {
				for (var path:String in _loadMap) {
					remove(path);
				}
				_loadMap = null;
			}
			_length = NONE;
			_apply = null;
		}
		
		//---------------static-----------------
		//统一资源可以使用，省略了下载计时
		public static function loads(paths:Array, prior:Boolean = false, context:*= undefined, version:String = null):DownLoader
		{
			var loader:DownLoader = new DownLoader();
			var path:String;
			var i:int = 0;
			if (prior) {
				for (i = paths.length - 1; i >=0 ; i--) {
					path = paths[i];
					loader.loadRequest(new LoadRequest(path, version, context), true);
				}
			}else {
				for (i = 0; i < paths.length; i++) {
					path = paths[i];
					loader.loadRequest(new LoadRequest(path, version, context), false);
				}
			}
			return loader;
		}
		//
	}

}