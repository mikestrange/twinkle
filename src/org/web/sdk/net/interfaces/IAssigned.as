package org.web.sdk.net.interfaces 
{
	import flash.net.Socket;
	
	public interface IAssigned 
	{
		function unpack(socket:Socket):void;
		function restore():void;
		//ends
	}
	
}