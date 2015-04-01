package org.web.sdk.load.loads 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import org.web.sdk.load.CheckLoader;
	import org.web.sdk.load.interfaces.ILoader;
	import org.web.sdk.load.interfaces.ILoadRequest;
	import org.web.sdk.load.LoadEvent;
	
	/*
	 * 数据加载，包括文本或二进制
	 * 如果需要监听下载百分比，继承他就可以了,只需要扩张eventListener
	 * */
	
	public class TextLoader extends URLLoader implements ILoader 
	{
		private var _url:String;
		protected var _isLoader:Boolean = false;
		
		//解析类型
		protected function getFormat():String
		{
			return URLLoaderDataFormat.TEXT;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function getRequest():ILoadRequest
		{
			return null;
		}
		
		public function download(request:ILoadRequest):void
		{
			_url = request.url;
			eventListener();
			this.dataFormat = getFormat();
			this._isLoader = true;
			this.load(new URLRequest(_url));
		}
		
		protected function eventListener():void
		{
			this.addEventListener(Event.COMPLETE, complete);
			this.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this.addEventListener(Event.OPEN, onOpen);
			this.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		protected function removeListener():void
		{
			this.removeEventListener(Event.COMPLETE, complete);
			this.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this.removeEventListener(Event.OPEN, onOpen);
			this.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		protected function onOpen(event:Event):void
		{
			invoke(LoadEvent.OPEN);
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			invoke(LoadEvent.OPRESS, event);
		}
		
		protected function complete(e:Event):void
		{
			removeListener();
			_isLoader = false;
			invoke(LoadEvent.COMPLETE, this.data);
		}
		
		protected function onError(e:IOErrorEvent):void
		{
			removeListener();
			_isLoader = false;
			invoke(LoadEvent.ERROR);
		}
		
		public function destroy():void 
		{
			if (_isLoader) {
				removeListener();
				_isLoader = false;
				try {
					super.close();
				}catch (e:Error) {
					trace("下载关闭出错！");
				}
			}
		}
		
		protected function invoke(type:String, data:Object = null):void
		{
			CheckLoader.dispatchs(_url, type, data);
		}
		//ends
	}

}