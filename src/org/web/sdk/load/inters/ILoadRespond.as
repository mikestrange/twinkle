package org.web.sdk.load.inters 
{
	public interface ILoadRespond 
	{
		function addRespond(called:Function, only:Object = null):void;
		function get context():*;
		function get type():int;
		function get url():String;
		function get size():int;
		//ends
	}
	
}