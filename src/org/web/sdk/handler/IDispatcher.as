package org.web.sdk.handler 
{
	import org.web.sdk.handler.EventedDispatcher;
	
	public interface IDispatcher 
	{
		function addNotice(notice:String, called:Function):void;
		function removeNotice(notice:String, called:Function):void;
		function isset(notice:String):Boolean;					
		function removeLink(notice:String = null):void;
		function dispatchNotice(notice:String, ...events):void;
		//eds
	}
	
}