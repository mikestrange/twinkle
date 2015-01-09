package org.web.sdk.load.inters 
{
	import flash.events.IEventDispatcher;
	
	public interface ILoader extends IEventDispatcher 
	{
		function get url():String;
		function downLoad(path:String, context:*= undefined, called:Function = null):void;
		function close():void;
		//ends
	}
}