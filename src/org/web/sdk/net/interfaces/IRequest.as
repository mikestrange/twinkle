package org.web.sdk.net.interfaces 
{
	public interface IRequest 
	{
		function sendRequest(message:Object, socket:INetwork = null):void;
		function getCmd():uint;
	}
}