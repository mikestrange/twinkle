package org.web.sdk.load.interfaces 
{
	
	public interface ILoader 
	{
		function download(request:ILoadRequest):void;
		function getRequest():ILoadRequest;
		function destroy():void;
	}
	
}