package org.web.sdk.net.handler 
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import org.web.sdk.net.interfaces.INetHandler;
	import org.web.sdk.net.interfaces.INetwork;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.GlobalMessage;
	import org.web.sdk.system.inter.IMessage;
	/*
	 * 一个数据包，包含了发送者，这里作为中转，处理过后直接派发命令,这里必须是全局的一种发送，不必设定一个Message
	 * */
	public class RespondEvented
	{
		public var cmd:Number;
		public var filed:Boolean;
		public var socket:INetwork;
		//需要被解析的数据
		public var proto:* = undefined;
		
		public function RespondEvented(cmd:Number, socket:INetwork = null, proto:* = undefined, filed:Boolean = false) 
		{
			this.cmd = cmd;
			this.socket = socket;
			this.filed = filed;	//没有处理过
			this.proto = proto;
		}
		
		//处理过
		public function isMatter():Boolean
		{
			return filed;
		}
		
		public function shut():void
		{
			filed = true;
		}
		
		//一般情况不必改变
		protected function getMessage():IMessage
		{
			return GlobalMessage.gets();
		}
		
		//每一个处理器处理之后都会发送命令 ,没有处理直接发送命令
		public function invoke(notice:String, result:INetHandler = null):void
		{
			//不解析
			if (null == result) {
				getMessage().sendMessage(notice, null, this, Evented.ERROR_TYPE);
			}else {
				//解析->   返回true就证明之前有处理过,之后的处理或者不处理不需要它关心
				result.action(proto);
				//发送解析后的事务
				getMessage().sendMessage(notice, result.getMessage(), this, Evented.SERVER_MESSAGE);
			}
		}
		//ends
	}

}