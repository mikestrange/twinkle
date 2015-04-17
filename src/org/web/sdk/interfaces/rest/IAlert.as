package org.web.sdk.interfaces.rest 
{
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 小提示
	 */
	public interface IAlert 
	{
		function get type():int;
		function show(type:int, data:Object):void;
		function hide():void;
		function closed():void;			//自身执行
		//ends
	}
	
}