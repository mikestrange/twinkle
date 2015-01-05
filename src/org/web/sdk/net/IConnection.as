package org.web.sdk.net 
{

	public interface IConnection 
	{
		function closed():void;
		function setAddress(url:String):void;
		function set acceptHandler(value:Function):void;
		function send(module:String, order:String , data:Object, client:*, code:uint):void;
		//ends
	}
}