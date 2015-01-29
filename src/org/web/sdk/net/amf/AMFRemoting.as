package org.web.sdk.net.amf
{
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
		private var _line:Boolean = false;
		
		public function set responder(value:Responder):void 
		{
			_responder = value;
		}
		
		public function destroy():void
		{
			if (!_line) return;
			_line = false;
			this.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this.close();
		}
		
		//连接远程服务
		public function connectRemote(gateway:String, amfType:uint = ObjectEncoding.AMF3):void
		{
			if (_line) return;
			_line = true;
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
			Log.log(this).error("AMF code:", event.info.code);
			triggerInfocode(event.info.code);
		}
		
		//回执错误或者成功
		protected function triggerInfocode(code:String):void
		{
			
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void
		{
			Log.log(this).error("网络错误 AMF Remoting 连接错误:", event);
		}
		
		//发送远程
		public function sendRemoting(remoteMethod:String, bodyList:Array = null):void
		{
			if (null == bodyList) bodyList = [];
			bodyList.unshift(remoteMethod, _responder);
			this.call.apply(this, bodyList);
		}
		
		//回执 调用全局消息,可以通过CMD调用
		protected function onResult(response:Object):void
		{
			//message,body,type
			trace('AMF Server: ' + response);
		}
		
		//错误处理
		protected function onFault(response:Object = null):void
		{
			//errorType,data
			 trace('AMF Client error:', response);
		}
		
		
		public static function test():void
		{
			var amf:AMFRemoting = new AMFRemoting;
			amf.connectRemote("http://localhost:80/amfphp-2.2.1/Amfphp/index.php");
			amf.sendRemoting('ExampleService.returnBla');
		}
		
		//ends
	}
}