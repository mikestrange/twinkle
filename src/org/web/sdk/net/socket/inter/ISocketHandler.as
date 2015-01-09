package org.web.sdk.net.socket.inter 
{
	import org.web.sdk.net.socket.base.FtpRead;
	import org.web.sdk.net.socket.handler.RespondEvented;
	
	public interface ISocketHandler 
	{
		function action(event:RespondEvented):Boolean;		//返回是否处理
		function getMessage():Object;						//记过值
		//ends
	}
	
}