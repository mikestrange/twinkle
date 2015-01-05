package org.web.sdk.net.http 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.system.Security;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import org.web.sdk.log.Log;
	import org.web.sdk.net.events.HttpEvent;
	import org.web.sdk.net.IConnection;
	
	public class HttpConnection extends EventDispatcher implements IConnection 
	{
		///-----通信地址
		protected var serverUrl:String = "http://localhost/test.php";
		//
		protected var onLine:Array;
		protected var loader:URLLoader;
		protected var _acceptHandler:Function;
		public const _ZERO_:int = 0;
		private var isrequest:Boolean = false;
		
		public function HttpConnection() 
		{
			onLine = new Array;
			initialize();
		}
		
		protected function initialize():void 
		{
			loader = new URLLoader;
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
		}
		
		/* INTERFACE org.web.direct.sdk.net.http.IConnection */
		//请求结束，处理函数
		public function setAddress(url:String):void
		{
			serverUrl = url;
		}
		
		public function set acceptHandler(value:Function):void 
		{
			_acceptHandler = value;
		}
		
		public function isRequest():Boolean
		{
			return isrequest;
		}
		
		//关闭或者清理
		public function closed():void
		{
			try{
				loader.close();
			}catch (e:Error) {
				Log.log(this).debug('http未开始请求的断开');
			}finally {
				isrequest = false;
				if (onLine.length) onLine.splice(0, onLine.length);
			}
		}
		
		//发送给服务器-----数据未经过处理，请处理  data   code只是一个标示
		public function send(module:String, order:String , data:Object, client:*, code:uint):void 
		{
			onLine.push(new HttpData(module, order, data, client, code));
			sendNext();
		}
		
		protected function sendNext():void
		{
			if (isRequest()) return;
			if (_ZERO_ == onLine.length) return;
			isrequest = true;
			loader.load(getHttpRequest(onLine[_ZERO_] as HttpData));
		}
		
		////基本上复写他就可以实现不同传输方式
		protected function getHttpRequest(http:HttpData, method:String = null):URLRequest
		{
			var indexUrl:String = this.serverUrl;
			indexUrl = indexUrl + (indexUrl.indexOf("?") >= 0 ? ("&") : ("?")); 
			indexUrl = indexUrl + "c=" + http.module + "&a=" + http.order +"&code=" + http.code;
			var body:Object= http.data;
			var key:*;
			var item:*;
			for (key in body)
			{
				item = body[key];
				if (null != item && undefined != item && (item is Number || item is String || item is Boolean))
				{
					indexUrl += (item is Number && isNaN(item))?("&" + key + "=0"):("&" + key + "=" + item);
				}
			}
			Log.log(this).debug("->取数据地址是:" + indexUrl);
			return getRequest(indexUrl, "get", http.data);
		}
		
		//如果还有，那么继续请求
		protected function completeHandler(e:Event):void
		{
			var http:HttpData = getNextHttpData();
			http.data = e.target.data;
			Log.log(this).debug("->回执数据是:" + e.target.data);
			//处理下一个
			isrequest = false;
			sendNext();
			//发送到数据处理
			if (_acceptHandler is Function) _acceptHandler(http);
			//回调事件
			this.dispatchEvent(new HttpEvent(HttpEvent.COMPLETE));
		}
		
		private function getNextHttpData():HttpData
		{
			return onLine.shift() as HttpData;
		}
		
		//链接错误
		protected function onErrorHandler(e:Event):void
		{
			Log.log(this).error("Error for Http 404:请确保连接上了后台,未知端口！");
			this.dispatchEvent(new HttpEvent(HttpEvent.ERROR));
		}
		
		//携带者 可以做全局，不必每次都new
		protected function getRequest(url:String, method:String = "post", data:*= null):URLRequest
		{
			var request:URLRequest = new URLRequest(url);
			//request.data = data;
			request.method = method;
			return request;
		}
		
		//ends
	}
}



