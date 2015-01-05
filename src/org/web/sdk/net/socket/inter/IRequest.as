package org.web.sdk.net.socket.inter 
{
	import org.web.sdk.net.socket.inter.ISocket;
	
	public interface IRequest 
	{
		function sendRequest(message:Object, socket:ISocket = null):void;
		function getCmd():uint;
	}
}