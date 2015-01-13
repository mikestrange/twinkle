package org.web.sdk.net.socket.handler 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.web.sdk.net.socket.base.FtpRead;
	import org.web.sdk.net.socket.inter.ISocket;
	import org.web.sdk.net.socket.inter.ISocketHandler;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.GlobalMessage;
	
	public class RespondEvented extends FtpRead 
	{
		private var socket:ISocket;
		private var filed:Boolean;
		private var cmd:Number;
		private var hashMessage:Dictionary;
		
		public function RespondEvented(cmd:Number, socket:ISocket = null, byte:ByteArray = null) 
		{
			this.cmd = cmd;
			this.socket = socket;
			this.hashMessage = new Dictionary;
			super(byte);
		}
		
		//处理过
		public function isTreated():Boolean
		{
			return filed;
		}
		
		public function getCmd():Number
		{
			return this.cmd;
		}
		
		public function getSocket():ISocket
		{
			return socket;
		}
		
		public function getBody(notice:String):Object
		{
			return this.hashMessage[notice];
		}
		
		//每一个处理器处理之后都会发送命令 ,没有处理直接发送命令
		public function invoke(notice:String, result:ISocketHandler = null):void
		{
			if (null == result) {
				GlobalMessage.sendMessage(notice, null, this, Evented.ERROR_TYPE);
			}else {
				filed = result.action(this);
				//这里保存命令发送的所有数据 我们先不这么做
				//this.hashMessage[notice] = result.getMessage();				
				GlobalMessage.sendMessage(notice, result.getMessage(), this, Evented.SERVER_MESSAGE);
			}
		}
		//
	}

}