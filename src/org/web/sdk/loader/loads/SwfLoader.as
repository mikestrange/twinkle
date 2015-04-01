package org.web.sdk.loader.loads 
{
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import org.web.sdk.loader.CheckLoader;
	import org.web.sdk.loader.interfaces.ILoader;
	import org.web.sdk.loader.interfaces.ILoadRequest;
	import org.web.sdk.loader.LoadEvent;
	
	/*
	 * swf下载
	 * 如果需要监听下载百分比，继承他就可以了,只需要扩张eventListener
	 * */
	public class SwfLoader extends Loader implements ILoader
	{
		private var _url:String;
		protected var _isLoader:Boolean = false;
		
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
			_isLoader = true;
			this.load(new URLRequest(_url), request.context);
		}
		
		protected function eventListener():void
		{
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			this.contentLoaderInfo.addEventListener(Event.OPEN, onOpen);
			this.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		protected function removeListener():void
		{
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			this.contentLoaderInfo.removeEventListener(Event.OPEN, onOpen);
			this.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		protected function onOpen(event:Event):void
		{
			invoke(LoadEvent.OPEN);
		}
		
		protected function onProgress(event:ProgressEvent):void
		{
			invoke(LoadEvent.OPRESS, event);
		}
		
		protected function complete(event:Event):void
		{
			removeListener();
			_isLoader = false;
			invoke(LoadEvent.COMPLETE, this);
		}
		
		protected function onError(event:IOErrorEvent):void
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