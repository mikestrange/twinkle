package org.web.sdk.loader.interfaces 
{
	
	public interface ILoadRequest 
	{
		function get url():String;
		function get version():String;
		function get context():*;
		//end
	}
	
}