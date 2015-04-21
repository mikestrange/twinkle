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
		//结束调用
		private var _complete:Function;
		//观察表
		private var _loadMap:Dictionary;
		//未完成列表
		private var _length:int;
		
		public function DownLoader(complete:Function = null)
		{
			_complete = complete;
		}
		
		//固定下载
		public function load(url:String, context:*= undefined, version:String = null, priority:int = 0):ILoadRequest
		{
			var request:ILoadRequest = new LoadRequest(url, version, context, priority);
			loadRequest(request);
			return request;
		}
		
		//一个下载器不重复添加同名下载，控制版本和请求地址是不一样的
		public function loadRequest(request:ILoadRequest):ILoadRequest
		{
			if (isHave(request.url)) return request;
			if (null == _loadMap) _loadMap = new Dictionary;
			_loadMap[request.url] = request;
			++_length;
			CheckLoader.putStack(request, this);
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
		
		//结束回调
		public function set completeHandler(value:Function):void
		{
			_complete = value;
		}
		
		//这里下载器提供回调，就算结束也不会清理下载队列
		internal function eventResult(event:LoadEvent):void
		{
			if (event.isOver) {
				remove(event.url);
				if (_complete is Function) _complete(event);
			}else {
				//下载的时候或者Open的时候
				if (_apply is Function) _apply(event);
			}
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
			_complete = null;
		}
		//
	}

}