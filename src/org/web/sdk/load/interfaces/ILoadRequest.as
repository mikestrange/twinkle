package org.web.sdk.load.interfaces 
{
	
	public interface ILoadRequest 
	{
		function get url():String;
		function get version():String;
		function get context():*;
		function get type():String;
		//end
	}
	
}