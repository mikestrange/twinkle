package org.web.sdk.net.interfaces 
{
	import org.web.sdk.net.RespondEvented;
	
	public interface INetHandler 
	{
		function netHandler(event:RespondEvented):void;		//返回是否处理
		function action():void;								//记过值
		//ends
	}
	
}