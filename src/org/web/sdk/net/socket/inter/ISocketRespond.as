package org.web.sdk.net.socket.inter 
{
	import org.web.sdk.net.socket.base.FtpRead;
	import org.web.sdk.net.events.RespondEvented;
	
	public interface ISocketRespond 
	{
		function action(cmd:uint, event:RespondEvented = null):void;
		function getMessage():Object;
		//ends
	}
	
}