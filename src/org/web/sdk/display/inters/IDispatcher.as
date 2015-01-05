package org.web.sdk.display.inters 
{
	import org.web.sdk.display.core.EventedDispatcher;
	
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