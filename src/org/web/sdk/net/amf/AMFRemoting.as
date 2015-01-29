package org.web.sdk.net.amf
{
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import org.web.sdk.log.Log;
	
	public class AMFRemoting extends NetConnection
	{
		private var _responder:Responder;
		private var _line:Boolean = false;
		
		public function destroy():void
		{
			if (!_line) return;
			_line = false;
			this.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			this.close();
		}
		
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
		
		protected function triggerInfocode(code:String):void
		{
			switch(code)
			{
				case "NetConnection.Connect.Success":
						Log.log(this).error("AMF Remoting 连接成功:", code);
					break;
				default:
					break;
			}
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
		protected function onResult(data:Object):void
		{
			//message,body,type
		}
		
		//错误处理
		protected function onFault(data:Object):void
		{
			//errorType,data
		}
		
		
		//ends
	}
}