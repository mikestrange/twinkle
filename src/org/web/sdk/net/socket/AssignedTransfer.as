package org.web.sdk.net.socket 
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import org.web.sdk.log.Log;
	import org.web.sdk.net.CmdManager;
	import org.web.sdk.net.RespondEvented;
	import org.web.sdk.net.interfaces.IAssigned;
	import org.web.sdk.net.interfaces.INetwork;
	import org.web.sdk.net.utils.TcpRead;

	
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
					underhand(socket, byteBuff); 	//密传
					if (socket.bytesAvailable > ZERO) unpack(socket);
				}
			}else {
				//如果字节没有包头 那么不会处理数据
				if (socket.bytesAvailable >= INT) {
					if (byteBuff.length > ZERO) {
						byteBuff.clear();
						byteBuff.position = ZERO;
					}
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
		protected function underhand(socket:Socket, byte:ByteArray):void
		{
			//trace('->接收到服务器数据包:', byte.length);
			//固化解析包
			byte.position = 0;
			var cmd:uint = byte.readUnsignedInt();
			var type:int = byte.readUnsignedShort();
			//派发命令事务
			CmdManager.respondHandler(new RespondEvented(cmd, socket as INetwork, new TcpRead(createByteArray(byte))));
		}
		
		//把长度包分装
		protected function createByteArray(byte:ByteArray):ByteArray
		{
			var data:ByteArray = new ByteArray;
			byte.readBytes(data, 0, byte.bytesAvailable);
			data.position = ZERO;
			return data;
		}
		
		//ends
	}

}