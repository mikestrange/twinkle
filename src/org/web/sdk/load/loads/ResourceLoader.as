package org.web.sdk.load.loads 
{
	import flash.events.ProgressEvent;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import org.web.sdk.load.inters.ILoader;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import org.web.sdk.load.LoadEvent;
	
	/*
	 * swf下载
	 * 如果需要监听下载百分比，继承他就可以了,只需要扩张eventListener
	 * */
	public class ResourceLoader extends Loader implements ILoader
	{
		protected var _url:String;
		protected var _complete:Function;
		
		public function get url():String
		{
			return _url;
		}
		
		public function downLoad(path:String, context:*= undefined, called:Function = null):void
		{
			_url = path;
			_complete = called;
			eventListener();
			this.load(new URLRequest(_url), context);
		}
		
		protected function eventListener():void
		{
			this.contentLoaderInfo.addEventListener(Event.COMPLETE, complete, false, 0, true);
			this.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
		}
		
		protected function removeListener():void
		{
			this.contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
			this.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		protected function complete(e:Event):void
		{
			removeListener();
			invoke(e.target.loader, LoadEvent.COMPLETE);
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