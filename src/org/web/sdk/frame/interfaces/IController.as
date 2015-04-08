package org.web.sdk.frame.interfaces 
{
	/*
	 * 模块的初始化和逻辑中心
	 * ------------
	 * 他只对数据表和Command感兴趣
	 * */
	public interface IController 
	{
		function getName():String;
		function launch():void;
		function free():void;
		//ends
	}
	
}