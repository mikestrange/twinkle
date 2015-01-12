package org.web.sdk.load.inters 
{
	
	public interface ILoadController 
	{
		function start():void;
		function stop(share:Boolean = false):void;
		function remove(url:String, remove_load:Boolean = true):void;
		function free():void;
		//ends
	}
	
}