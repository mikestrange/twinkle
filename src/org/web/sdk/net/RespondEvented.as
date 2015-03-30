package org.web.sdk.net 
{
	import org.web.sdk.net.interfaces.INetwork;
	/*
	 * 一个数据包，包含了发送者，这里作为中转，处理过后直接派发命令,这里必须是全局的一种发送，不必设定一个Message
	 * */
	public class RespondEvented
	{
		public var cmd:Number;
		//发送者
		public var socket:INetwork;
		//需要被解析的数据
		public var proto:* = undefined;
		
		public function RespondEvented(cmd:Number, socket:INetwork, proto:* = undefined) 
		{
			this.cmd = cmd;
			this.socket = socket;
			this.proto = proto;
		}
		
		//ends
	}

}