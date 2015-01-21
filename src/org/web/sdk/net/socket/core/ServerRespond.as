package org.web.sdk.net.socket.core 
{
	import game.GameGlobal;
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
			if (event && !event.isMatter()) analyze(event.proto);
			else trace("#数据不能解析:", event.cmd);
		}
		
		protected function analyze(proto:FtpRead):void
		{
			
		}
		
		protected function get isdebug():Boolean
		{
			return GameGlobal.isDebug;
		}
		
		public function getMessage():Object
		{
			return this;
		}
		//ends
	}

}