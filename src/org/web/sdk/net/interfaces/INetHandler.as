package org.web.sdk.net.interfaces 
{
	import org.web.sdk.net.handler.RespondEvented;
	
	public interface INetHandler 
	{
		function action(event:RespondEvented):void;		//返回是否处理
		function getMessage():Object;						//记过值
		//ends
	}
	
}