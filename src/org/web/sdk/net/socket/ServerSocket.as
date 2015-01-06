package org.web.sdk.net.socket 
{
	import flash.errors.IOError;
	import flash.events.*;
	import flash.net.*;
	import flash.utils.*;
	import org.web.sdk.log.Log;
	import org.web.sdk.net.socket.inter.*;
	import org.web.sdk.system.GlobalMessage;
	
	public class ServerSocket extends Socket implements ISocket
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
			addEventListener(Event.CLOSE, eventToJava, false, 0, true);
			addEventListener(Event.CONNECT, eventToJava, false, 0, true);
			addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			addEventListener(ProgressEvent.SOCKET_DATA, socketRespond, false, 0, true);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurity, false, 0, true);
		}
		
		//移除监听并且关闭连接
		protected function remove():void
		{
			if (!isListener) return;
			isListener = false;
			removeEventListener(Event.CONNECT, eventToJava);
			removeEventListener(Event.CLOSE, eventToJava);
			removeEventListener(IOErrorEvent.IO_ERROR, onError);
			removeEventListener(ProgressEvent.SOCKET_DATA, socketRespond);
			removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurity);
		}
		
		//关闭套接字，是关闭flush
		public function closed():void
		{
			try {
				close();
			}catch (e:IOError) { 
				Log.log(this).debug("->socket关闭错误或端口未打开,非系统错误!");
			}finally {
				remove();
			}
		}
		
		protected function onSecurity(e:SecurityErrorEvent):void
		{
			Log.log(this).debug("#Error:安全沙箱错误")
		}
		
		//连接错误
		protected function onError(e:IOErrorEvent):void
		{
			Log.log(this).debug("#Error:socket连接失败!", this);
		}
		
		//连接和关闭
		private function eventToJava(e:Event):void
		{
			//无论是连接还是断开，都先清理下
			getAssigned().restore();
			//连接和断开
			switch(e.type)
			{
				case Event.CONNECT:
					if (_onLink is Function) _onLink(this);
					Log.log(this).debug("->socket打开连接");
					break;
				case Event.CLOSE:
					Log.log(this).debug("->socket关闭连接,你已和服务器断开连接！");	
					break;
			}
		}
		
		//数据接受 
		protected function socketRespond(e:ProgressEvent):void
		{
			//解包
			getAssigned().unpack(this);
			//发送外部事件->不需要发送外部事件
		}
		
		protected function writes(buff:ByteArray):void 
		{
			writeUnsignedInt(buff.length);
			super.writeBytes(buff, 0, buff.length);
		}
		
		//打包发送到服务器
		public function callFinal(byte:ByteArray):void
		{
			if (!connected) return;
			//Log.log(this).debug("发送字段：", byte.length);
			writes(byte);
			flush();
		}
		
		//通知调用,公开信
		public function sendNoticeRequest(request:IRequest, message:Object = null):void
		{
			Log.log(this).debug('->client 请求cmd: ' + request.getCmd());
			request.sendRequest(message, this);
		}
		
		//通过命令发送到服务器
		public function sendNotice(noticName:String, message:Object = null):void
		{
			GlobalMessage.sendMessage(noticName, message, this);
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