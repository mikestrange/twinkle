package org.web.sdk.net.web 
{
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import org.web.sdk.log.Log;
	import org.web.sdk.net.CmdManager;
	import org.web.sdk.net.RespondEvented;
	import org.web.sdk.net.interfaces.INetwork;
	import org.web.sdk.net.interfaces.INetRequest;
	
	public class WebConnection implements INetwork 
	{
		public static const _ZERO_:int = 0;
		//
		private var serverUrl:String = null;
		private var loader:URLLoader;
		private var lineList:Vector.<WebEvent>;
		private var iswait:Boolean = false;
		
		public function WebConnection(server:String = null) 
		{
			if (server) serverUrl = server;
			
			initialize();
		}
		
		protected function initialize():void 
		{
			lineList = new Vector.<WebEvent>;
			loader = new URLLoader;
			loader.addEventListener(Event.COMPLETE, complete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onerror);
		}
		
		public function getAddress():String
		{
			return serverUrl;
		}
		
		public function closed():void
		{
			try{
				loader.close();
			}catch (e:Error) {
				Log.log(this).debug('http未开始请求的断开');
			}finally {
				iswait = false;
				if (lineList.length) {
					lineList.splice(_ZERO_, lineList.length);
				}
			}
		}
		
		protected function onerror(e:IOErrorEvent):void
		{
			var web:WebEvent = lineList.shift();
			Log.log(this).error("Error for Http 404:请确保连接上了后台,未知端口！ url:" + web.url);
			sendNext();
			web.onStatus(404);
		}
		
		/* INTERFACE org.web.sdk.net.interfaces.INetwork */
		public function sendNoticeRequest(request:INetRequest, message:Object = null):void 
		{
			throw Error("短连接不适用");
		}
		
		//直接发送
		public function sendTick(cmd:int, body:Object = null, result:NetResult = null):void
		{
			var indexUrl:String
			if (cmd != -1) indexUrl = getAddress() + "?order=" + cmd;
			else indexUrl = getAddress();
			if (body) {
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
			}
			this.flushPacker(new WebEvent(cmd, indexUrl, result));
		}
		
		//用json打包发送
		public function flushPacker(pack:Object):void 
		{
			lineList.push(pack);	//添加
			if (iswait) return;
			sendNext();
		}
		
		protected function sendNext():void
		{
			if (lineList.length) {
				iswait = true;
				var web:WebEvent = lineList[_ZERO_];
				loader.load(getRequest(web.url));
			}else {
				iswait = false;
			}
		}
		
		//这里已经提供了json解析方式，如果要改变，那么就需要使用socket的解析方式
		protected function complete(e:Event):void
		{
			Log.log(this).debug("->回执数据是:" + e.target.data);
			var web:WebEvent = lineList.shift();
			sendNext();
			var data:Object = null;
			try {
				//json解析方式
				data = com.adobe.serialization.json.JSON.decode(e.target.data as String);
			}catch (e:Error) {
				Log.log(this).debug("json解析错误 Error:", e, "  ->url:" + web.url);
				data = null;
			}
			
			//当次回调->如果用异步，那么这里就不是这么处理了
			if (data) {
				web.onResult(data);	
			}else {
				web.onStatus();
				Log.log(this).debug("#url:", web.url, "   无回调!");
			}
		}
		
		//不会关闭当前
		public function remove(url:String):void
		{
			if (lineList.length == _ZERO_) return;
			//当前不会被删除和关闭
			for (var i:int = lineList.length - 1; i > _ZERO_; i--) {
				if (lineList[i].url == url) {
					lineList.splice(i, 1);
					break;
				}
			}
		}
		
		//携带者 可以做全局，不必每次都new
		protected function getRequest(url:String, data:*= null):URLRequest
		{
			Log.log(this).debug("请求数据 url:", url);
			var request:URLRequest = new URLRequest(url);
			//request.data = data;
			request.method = URLRequestMethod.GET;
			return request;
		}
		
		//ends
	}

}