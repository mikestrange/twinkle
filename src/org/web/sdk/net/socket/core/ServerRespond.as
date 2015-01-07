package org.web.sdk.net.socket.core 
{
	import org.web.sdk.log.Log;
	import org.web.sdk.net.socket.inter.*;
	import org.web.sdk.net.socket.RespondEvented;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.GlobalMessage;
	/*
	 * 处理服务器回执的数据包 
	 * */
	public class ServerRespond implements ISocketRespond 
	{
		
		//处理服务器的回执
		public function action(cmd:uint, event:RespondEvented = null):void
		{
			Log.log(this).debug("->server :cmd" + cmd, this);
		}
		
		public function getMessage():Object
		{
			return this;
		}
		
		//直接发送命令给前台
		protected function sendMessage(noticeName:String, data:Object = null):void
		{
			if (data == null) {
				GlobalMessage.sendMessage(noticeName, getMessage(),null,Evented.SERVER_CALL_CLIENT);
			}else {
				GlobalMessage.sendMessage(noticeName, data, null, Evented.SERVER_CALL_CLIENT);
			}
		}
		//ends
	}

}