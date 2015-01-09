package org.web.sdk.net.socket.handler 
{
	import flash.utils.Dictionary;
	import org.web.sdk.handler.Observer;
	import org.web.sdk.net.socket.handler.RespondEvented;
	import org.web.sdk.net.socket.inter.ICmdConverter;
	import org.web.sdk.net.socket.inter.ISocketHandler;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.utils.UniqueHash;
	
	/*
	 * 处理命令的转换器，基类
	 * */
	public class RespondConverter implements ICmdConverter 
	{
		public function register():void
		{
			
		}
		
		public function registerHandler(cmd:Number, called:Function):void
		{
			CmdManager.cmdHanlder(cmd, called, this);
		}
		
		public function removeHandler(cmd:Number, called:Function):void
		{
			CmdManager.removeHandler(cmd, called, this);
		}
		
		public function destroy():void
		{
			
		}
		//ends
	}

}