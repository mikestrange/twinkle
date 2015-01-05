package org.web.sdk.net.socket.inter 
{
	import flash.utils.ByteArray;
	import org.web.sdk.net.socket.inter.IRequest;
	
	public interface ISocket 
	{
		function sendNoticeRequest(request:IRequest, message:Object = null):void;
		function callFinal(byte:ByteArray):void;
		function get endian():String;
		//ends
	}
}