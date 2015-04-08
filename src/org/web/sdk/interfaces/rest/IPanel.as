package org.web.sdk.interfaces.rest 
{
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 面板
	 */
	public interface IPanel 
	{
		function getPanelName():String;
		function onEnter(name:String, data:Object):void;
		function onExit(value:Boolean = true):void;
		function update(data:Object):void;
		function removeFromAdmin():void;		//自身移除调用,不能扩展
		//ends
	}
	
}