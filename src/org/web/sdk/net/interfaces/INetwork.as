package org.web.sdk.net.interfaces 
{
	public interface INetwork 
	{
		function sendNoticeRequest(request:INetRequest, message:Object = null):void;
		function flushPacker(pack:Object):void;
		function closed():void;
		//ends
	}
}