package org.web.sdk.net.socket.core 
{
	import org.web.sdk.net.interfaces.INetHandler;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.utils.FtpRead;
	/*
	 * 处理服务器回执的数据包 
	 * */
	public class ServerRespond implements INetHandler 
	{
		//处理服务器的回执
		public function action(event:RespondEvented):void
		{
			trace("event:", event);
			if (event && !event.isMatter()) readByte(event.proto);
		}
		
		protected function readByte(proto:FtpRead):void
		{
			
		}
		
		public function getMessage():Object
		{
			return this;
		}
		//ends
	}

}