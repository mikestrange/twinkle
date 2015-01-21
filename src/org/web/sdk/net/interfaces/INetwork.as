package org.web.sdk.net.interfaces 
{
	public interface INetwork 
	{
		function sendNoticeRequest(request:IRequest, message:Object = null):void;
		function flushTerminal(pack:* = undefined):void;
		function get endian():String;
		//ends
	}
}