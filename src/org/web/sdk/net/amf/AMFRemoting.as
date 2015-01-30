package org.web.sdk.net.amf
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.utils.getTimer;
	import org.web.sdk.log.Log;
	
	public class AMFRemoting extends NetConnection
	{
		private var _responder:Responder;
		
		public function set responder(value:Responder):void 
		{
			_responder = value;
		}
		
		public function destroy():void
		{
			if (this.connected) {
				this.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				this.close();
			}
		}
		
		//连接远程服务
		public function connectRemote(gateway:String, amfType:uint = ObjectEncoding.AMF3):void
		{
			if (connected) return;
			if (null == _responder) _responder = new Responder(onResult, onFault);
			try {
				this.objectEncoding = amfType;
				this.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
				this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
				this.connect(gateway);
			}catch (e:Error) {
				Log.log(this).error("连接AMF错误：", e);
			}
		}
		
		private function netStatusHandler(event:NetStatusEvent):void
		{
			Log.log(this).debug("AMF status code:", event.info.code);
			triggerInfocode(event.info.code);
		}
		
		//回执错误或者成功
		protected function triggerInfocode(code:String):void
		{
			switch(code)
			{
				case "NetConnection.Call.BadVersion":
					Log.log(this).error("版本错误或者回传的数据有问题");
					break;
				case "NetConnection.Call.Failed ":
					Log.log(this).error("找不到远程接口或者API路径错误");
					break;
			}
		}
		
		protected function securityErrorHandler(event:SecurityErrorEvent):void
		{
			Log.log(this).error("网络错误 AMF Remoting 连接错误:", event);
		}
		
		//发送远程
		public function sendRemoting(remoteMethod:String, bodyList:Array = null, called:Function = null):void
		{
			if (null == bodyList) bodyList = [];
			bodyList.unshift(remoteMethod, _responder);
			this.call.apply(this, bodyList);
		}
		
		//回执 调用全局消息,可以通过CMD调用
		protected function onResult(response:Object):void
		{
			Log.log(this).debug('AMF Server return Client: ' + response);
		}
		
		//错误处理
		protected function onFault(response:Object = null):void
		{
			Log.log(this).debug('AMF Server return Error:', response);
		}
		
		//
		public static function test():void
		{
			var amf:AMFRemoting = new AMFRemoting;
			amf.connectRemote("http://localhost:80/amfphp-2.2.1/Amfphp/index.php");
			amf.sendRemoting('LogicService.logic');
		}
		
		//ends
	}
}