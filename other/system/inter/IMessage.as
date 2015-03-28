package org.web.sdk.system.inter 
{
	import org.web.sdk.system.com.Invoker;
	/*
	 * 通信集合了[所有的命令COM]和所有的回执事件[Event]
	 * */
	public interface IMessage 
	{
		//事件
		function addMessage(name:String, called:Function):void;
		function removeMessage(name:String, called:Function):void;
		function isMessage(name:String):Boolean;
		function removeLink(name:String = null):void; 
		function sendBody(name:String, body:Object = null):void; 
		function sendMessage(name:String, data:Object = null, client:*= undefined, type:uint = 0):void;
		//命令
		function eachQuitInvoker():void;
		function addInvoker(name:String, invoker:Invoker):Boolean;
		function isInvoker(name:String):Boolean;
		function removeInvoker(name:String):Boolean;
		//ends
	}
	
}