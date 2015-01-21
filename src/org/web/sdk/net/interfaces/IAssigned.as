package org.web.sdk.net.interfaces 
{
	import flash.net.Socket;
	/*
	 * 解析包的处理
	 * */
	public interface IAssigned 
	{
		function unpack(socket:Socket):void;
		function restore():void;
		//ends
	}
	
}