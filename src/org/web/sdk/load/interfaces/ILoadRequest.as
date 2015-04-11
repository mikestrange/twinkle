package org.web.sdk.load.interfaces 
{
	
	public interface ILoadRequest 
	{
		function get url():String;
		function get type():String;
		function get version():String;
		function get loadUrl():String;
		function get context():*;
		//end
	}
	
}