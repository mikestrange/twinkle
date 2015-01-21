package org.web.sdk.net.interfaces 
{
	/*
	 * net所有发送一个入口数据
	 * */
	public interface INetRequest 
	{
		function sendRequest(message:Object, socket:INetwork = null):void;
		function getCmd():uint;
	}
}