package org.web.sdk.frame.made.interfaces 
{
	/*
	 * 包装处理装置
	 * */
	public interface IWrapper 
	{
		function match(value:Object):Boolean;
		function isLive():Boolean;
		function destroy():void;
		function handler(event:Object):void;
		//end
	}
	
}