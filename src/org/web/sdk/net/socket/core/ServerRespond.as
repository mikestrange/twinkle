package org.web.sdk.net.socket.core 
{
	import org.web.sdk.log.Log;
	import org.web.sdk.net.socket.inter.*;
	import org.web.sdk.net.socket.handler.RespondEvented;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.GlobalMessage;
	/*
	 * 处理服务器回执的数据包 
	 * */
	public class ServerRespond implements ISocketHandler 
	{
		
		//处理服务器的回执
		public function action(event:RespondEvented):Boolean
		{
			return false;
		}
		
		public function getMessage():Object
		{
			return this;
		}
		//ends
	}

}