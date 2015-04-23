package org.web.sdk.net 
{
	import org.web.sdk.net.interfaces.INetwork;
	/*
	 * 网络事件
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