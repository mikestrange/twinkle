package org.web.sdk.load 
{
	public interface IRespond 
	{
		function addRespond(mark:String, called:Function, only:Object = null):void;
		function get context():*;
		function get type():int;
		function get url():String;
		function get size():int;
		//ends
	}
	
}