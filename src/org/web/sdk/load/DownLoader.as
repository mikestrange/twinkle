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
		
		//统一资源可以使用
		public function loads(urls:Array, prior:Boolean = false, context:*= undefined, version:String = null):void
		{
			var url:String;
			var i:int = 0;
			if (prior) {
				for (i = urls.length - 1; i >=0 ; i--) {
					url = urls[i];
					loadRequest(new LoadRequest(url, version, context), true);
				}
			}else {
				for (i = 0; i < urls.length; i++) {
					url = urls[i];
					loadRequest(new LoadRequest(url, version, context), false);
				}
			}
		}
		
		//固定下载
		public function load(url:String, context:*= undefined, version:String = null, prior:Boolean = false):void
		{
			loadRequest(new LoadRequest(url, version, context), prior);
		}
		
		//一个下载器不重复添加同名下载，控制版本和请求地址是不一样的
		protected function loadRequest(request:ILoadRequest, prior:Boolean = false):void
		{
			if (isHave(request.url)) return;
			if (null == _loadMap) _loadMap = new Dictionary;
			_loadMap[request.url] = request;
			++_length;
			CheckLoader.putStack(request, this, prior);
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
		
		public function isHave(url:String):Boolean
		{
			if (null == _loadMap) return false;
			return _loadMap[url] != undefined;
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
		public function remove(url:String):void 
		{
			if (isHave(url)) 
			{
				--_length;
				delete _loadMap[url];
				if (_length == NONE) _loadMap = null;
				CheckLoader.removeLoader(url, this);
			}
		}
		
		//清理自身的下载
		public function clean():void
		{
			if (_loadMap) {
				for (var url:String in _loadMap) {
					remove(url);
				}
				_loadMap = null;
			}
			_length = NONE;
			_apply = null;
		}
		//
	}

}