package org.web.sdk.handler 
{
	import org.web.sdk.handler.EventedDispatcher;
	
	public interface IDispatcher 
	{
		function listenfor(newName:String, called:Function):void;
		function removeListener(newName:String, called:Function):void;
		function isset(newName:String):Boolean;					
		function removeLink(newName:String = null):void;
		function handler(newName:String, newRest:Object = null):void;
		function get allow():Boolean;
		//eds
	}
	
}