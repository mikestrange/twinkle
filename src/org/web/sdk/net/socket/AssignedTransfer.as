package org.web.sdk.net.socket 
{
	import flash.utils.getTimer;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import org.web.sdk.log.Log;
	import org.web.sdk.net.socket.base.*;
	import org.web.apk.beyond_challenge;
	import org.web.sdk.net.socket.inter.IAssigned;
	import org.web.sdk.net.socket.inter.ISocket;
	import org.web.sdk.net.socket.inter.ISocketRespond;
	
	use namespace beyond_challenge
	
	public class AssignedTransfer implements IAssigned 
	{
		//包头32位
		private const INT:int = 4;
		//常量0
		private const ZERO:int = 0;
		//包头长度
		private var btLeng:uint = 0;
		//断点数据
		private var byteBuff:ByteArray = new ByteArray;
		//是否读到包头长度
		private var isReadTop:Boolean;
		
		//解析socket
		public function unpack(socket:Socket):void 
		{
			if (isReadTop) {
				//累计数据，完成一个数据包后发送出去
				if (socket.bytesAvailable >= btLeng) {
					socket.readBytes(byteBuff, ZERO, btLeng);
					isReadTop = false;
					underhand(socket,byteBuff); 	//密传
					if (socket.bytesAvailable > ZERO) unpack(socket);
				}
			}else {
				//如果字节没有包头 那么不会处理数据
				if (socket.bytesAvailable >= INT) {
					if (byteBuff.length > ZERO) {
						byteBuff.clear();
						byteBuff.position = ZERO;
					}
					byteBuff.endian = socket.endian;	// 设置大小端
					isReadTop = true;
					btLeng = socket.readUnsignedInt();	//包长度
					if (socket.bytesAvailable > ZERO) unpack(socket);
				}
			}
		}
		
		//恢复，还原
		public function restore():void
		{
			isReadTop = false;
			btLeng = ZERO;
			if (byteBuff.length > ZERO) {
				byteBuff.clear();
				byteBuff.position = ZERO;
			}
		}
		
		//这里对外传入一个完整的数据包,服务只要传过来数据包就可以了，其他的这边会处理
		beyond_challenge function underhand(socket:Socket,byte:ByteArray):void
		{
			//trace('->接收到服务器数据包:', byte.length);
			//固化解析包
			var newByte:ByteArray = createByteArray(byte);
			handler(new RespondEvented(socket as ISocket, newByte));
		}
		
		//把长度包分装
		beyond_challenge function createByteArray(byte:ByteArray, position:int = 0):ByteArray
		{
			var data:ByteArray = new ByteArray;
			data.endian = byte.endian;	//设置大小端
			byte.position = position;
			byte.readBytes(data, ZERO, byte.bytesAvailable);
			data.position = ZERO;
			return data;
		}
		
		//继承在这里处理就可以了,至于怎么解析自己决定
		protected function handler(ftp:RespondEvented):void
		{
			var cmd:uint = ftp.readUint();						//1-uint.MAX_VALUE这里是具体的命令
			var type:int = ftp.readShort();
			//取回执
			action(cmd, ftp);
		}
		
		//正确发送
		protected function action(cmd:int, ftp:RespondEvented):void
		{
			var respond:ISocketRespond = SocketModule.createRespond(cmd);
			Log.log(this).debug("->服务端推送命令:" + cmd, ',handler:', respond);
			if (respond) respond.action(cmd, ftp);
		}
		
		//ends
	}

}