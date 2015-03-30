package org.web.sdk.net.socket 
{
	import flash.errors.IOError;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import org.web.sdk.log.Log;
	import org.web.sdk.net.interfaces.*;
	
	public class ServerSocket extends Socket implements INetwork
	{
		//协同器
		private var _assigned:IAssigned;
		//服务
		private var isListener:Boolean = false;
		//
		private var _onLink:Function = null
		
		public function ServerSocket(assigned:IAssigned)
		{
			this._assigned = assigned;
		}
		
		public function link(host:String = '127.0.0.1', port:int = 0, complete:Function = null):void
		{
			if (this.connected) this.closed();
			this.endian = Endian.BIG_ENDIAN; //必须设置 网络包序的问题
			_onLink = complete;
			listener();
			super.connect(host, port);
		}
			
		//分包器
		public function getAssigned():IAssigned
		{
			return _assigned;
		}
		
		//注册事件
		protected function listener():void
		{
			if (isListener) return;
			isListener = true;
			objectEncoding = ObjectEncoding.AMF3;		//控制版本为AMF3 
			addEventListener(Event.CLOSE, eventServer, false, 0, true);
			addEventListener(Event.CONNECT, eventServer, false, 0, true);
			addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			addEventListener(ProgressEvent.SOCKET_DATA, socketRespond, false, 0, true);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurity, false, 0, true);
		}
		
		//移除监听并且关闭连接
		protected function remove():void
		{
			if (!isListener) return;
			isListener = false;
			removeEventListener(Event.CONNECT, eventServer);
			removeEventListener(Event.CLOSE, eventServer);
			removeEventListener(IOErrorEvent.IO_ERROR, onError);
			removeEventListener(ProgressEvent.SOCKET_DATA, socketRespond);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurity);
		}
		
		//关闭套接字，是关闭flush
		public function closed():void
		{
			try {
				close();
			}catch (event:IOError) { 
				Log.log(this).debug("->socket关闭错误或端口未打开,非系统错误!");
			}finally {
				remove();
			}
		}
		
		protected function onSecurity(event:SecurityErrorEvent):void
		{
			Log.log(this).debug("#Error:安全沙箱错误")
		}
		
		//连接错误
		protected function onError(event:IOErrorEvent):void
		{
			Log.log(this).debug("#Error:socket连接失败!", event);
		}
		
		//连接和关闭
		private function eventServer(event:Event):void
		{
			//无论是连接还是断开，都先清理下
			getAssigned().restore();
			//连接和断开
			switch(event.type)
			{
				case Event.CONNECT:
					if(_onLink is Function) _onLink(this);
					Log.log(this).debug("->socket打开连接");
					break;
				case Event.CLOSE:
					if(_onLink is Function) _onLink(null);
					Log.log(this).debug("->socket关闭连接,你已和服务器断开连接！");	
					break;
			}
		}
		
		//数据接受 
		protected function socketRespond(event:ProgressEvent):void
		{
			getAssigned().unpack(this);
		}
		
		//编码格式 ,默认ByteLength
		protected function setEncoded(base:Object):void 
		{
			var buff:ByteArray = base as ByteArray;
			writeUnsignedInt(buff.length);
			super.writeBytes(buff, 0, buff.length);
		}
		
		//最终通过它发送给服务器
		public function flushPacker(pack:Object):void
		{
			if (!connected) return;
			setEncoded(pack);
			flush();
		}
		
		//通知调用,公开信
		public function sendNoticeRequest(request:INetRequest, message:Object = null):void
		{
			Log.log(this).debug('->client 请求cmd: ' + request.command);
			request.batchProcess(message, this);
		}
		
		//初始化一次sockete
		private static var _socket:ServerSocket;
		
		public static function create(assigned:IAssigned):ServerSocket
		{
			if (null == _socket) {
				_socket = new ServerSocket(assigned);
			}
			return _socket;
		}
		
		public static function get socket():ServerSocket
		{
			return _socket;
		}
		//ends
	}
}