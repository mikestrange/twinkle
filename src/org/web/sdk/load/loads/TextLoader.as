package org.web.sdk.load.loads 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import org.web.sdk.load.ILoader;
	import org.web.sdk.load.LoadEvent;
	
	/*
	 * 数据加载，包括文本或二进制
	 * 如果需要监听下载百分比，继承他就可以了,只需要扩张eventListener
	 * */
	
	public class TextLoader extends URLLoader implements ILoader 
	{
		protected var _url:String;
		protected var _complete:Function;
		
		//解析类型
		protected function getFormat():String
		{
			return URLLoaderDataFormat.TEXT;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function downLoad(path:String, context:*= undefined, called:Function = null):void
		{
			_url = path;
			_complete = called;
			eventListener();
			this.dataFormat = getFormat();
			this.load(new URLRequest(_url));
		}
		
		protected function eventListener():void
		{
			this.addEventListener(Event.COMPLETE, complete, false, 0, true);
			this.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
		}
		
		protected function removeListener():void
		{
			this.removeEventListener(Event.COMPLETE, complete);
			this.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		protected function complete(e:Event):void
		{
			removeListener();
			invoke(e.target.data, LoadEvent.COMPLETE);
		}
		
		protected function onError(e:IOErrorEvent):void
		{
			removeListener();
			invoke(null, LoadEvent.ERROR);
		}
		
		override public function close():void 
		{
			removeListener();
			super.close();
		}
		
		protected function invoke(data:Object, type:String = null):void 
		{
			if (_complete is Function) _complete(data, type);
		}
		//ends
	}

}