package org.web.sdk.fot.interfaces 
{
	/*
	 * 一个带消息链的对象
	 * */
	public interface ITactful 
	{
		//是否累计
		function isCumulative():Boolean;
		//设置消息模式
		function setCumulative(value:Boolean):void;
		//设置消息链,必须携带监听人
		function setLinks(applistner:IApplicationListener, vector:Vector.<String>):void;
		//消息链
		function getLinks():Vector.<String>;
		//处理方法
		function tickEvent(name:String, event:Object = null):void;
		//监听人
		function getApplicationListener():IApplicationListener;
		//end
	}
	
}