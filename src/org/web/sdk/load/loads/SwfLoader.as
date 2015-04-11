package org.web.sdk.load.loads 
{
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import org.web.sdk.load.CheckLoader;
	import org.web.sdk.load.interfaces.ILoader;
	import org.web.sdk.load.interfaces.ILoadRequest;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.log.Log;
	
	/*
	 * swf下载
	 * 如果需要监听下载百分比，继承他就可以了,只需要扩张eventListener
	 * */
	public class SwfLoader extends Loader implements ILoader
	{
		private var _request:ILoadRequest;
		protected var _isLoader:Boolean = false;
		
		public function getRequest():ILoadRequest
		{
			return _request;
		}
		
		public function download(request:ILoadRequest):void
		{
			_request = request;
			_isLoader = true;
			eventListener();
			this.load(new URLRequest(request.loadUrl), request.context);
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
			if (this.contentLoaderInfo.hasEventListener(Event.COMPLETE)) {
				this.contentLoaderInfo.removeEventListener(Event.COMPLETE, onNewLoadComplete);
			}
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
			if (getRequest().context) {
				//解决跨域的问题，如果资源下载到本地域，那么我们内部不会停止
				this.contentLoaderInfo.addEventListener(Event.COMPLETE, onNewLoadComplete);
				this.loadBytes(this.contentLoaderInfo.bytes, getRequest().context);
			}else {
				_isLoader = false;
				invoke(LoadEvent.COMPLETE, this);
			}
		}
		
		protected function onError(event:IOErrorEvent):void
		{
			removeListener();
			_isLoader = false;
			invoke(LoadEvent.ERROR);
		}
		
		protected function onNewLoadComplete(event:Event):void
		{
			_isLoader = false;
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, onNewLoadComplete);
			invoke(LoadEvent.COMPLETE, this);
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
			CheckLoader.dispatchs(getRequest().url, type, data);
		}
		//ends
	}

}