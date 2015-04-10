package org.web.sdk.load.interfaces 
{
	
	public interface ILoadRequest 
	{
		function get version():String;
		function get context():*;
		function get type():String;
		//
		function get url():String;
		function set url(value:String):void;
		//end
	}
	
}