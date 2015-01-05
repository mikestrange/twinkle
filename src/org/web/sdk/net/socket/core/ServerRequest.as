package org.web.sdk.net.socket.core 
{
	import org.web.sdk.net.socket.inter.*;
	import org.web.sdk.net.socket.base.FtpWrite;
	
	/*
	 * 发送给服务器的数据,被socket调用，不自己发送
	 * */
	public class ServerRequest extends FtpWrite implements IRequest 
	{
		protected var cmd:uint;
		protected var type:int;
		
		public function ServerRequest(cmd:uint, type:int = 0) 
		{
			this.cmd = cmd;
			this.type = type;
		}
		
		public function sendRequest(message:Object, socket:ISocket = null):void
		{
			//设置大小端
			this.endian = socket.endian;
			//读取数据
			plumage(message);
			//发送到服务器
			socket.callFinal(getBytes());
		}
		
		public function getCmd():uint
		{
			return cmd;
		}
		
		//处理头或者其他
		protected function plumage(message:Object = null):void
		{
			this.writeUint(cmd);
			this.writeShort(type);
		}
		
		//ends
	}

}