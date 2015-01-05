package org.web.sdk.net.socket.core 
{
	import org.web.sdk.log.Log;
	import org.web.sdk.net.socket.inter.*;
	import org.web.sdk.net.socket.RespondEvented;
	import org.web.sdk.system.EternalMessage;
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
		
		protected function sendMessage(noticeName:String, data:Object = null):void
		{
			if (data == null) {
				EternalMessage.sendMessage(noticeName, getMessage());
			}else {
				EternalMessage.sendMessage(noticeName, data);
			}
		}
		//ends
	}

}