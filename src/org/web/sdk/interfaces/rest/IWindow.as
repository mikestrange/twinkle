package org.web.sdk.interfaces.rest 
{
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 面板
	 */
	public interface IWindow 
	{
		function getDefineName():String;
		function show(data:Object = null):void;
		function update(data:Object):void;
		function closed():void;		//自身移除调用,不能扩展
		//ends
	}
	
}