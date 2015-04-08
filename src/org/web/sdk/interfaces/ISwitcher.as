package org.web.sdk.interfaces 
{
	//切换器
	public interface ISwitcher 
	{
		//定义动作
		function defineAction(key:String, target:*= undefined):void;
		//设置默认
		function setNormal(target:*):void;
		//当前状态
		function setCurrent(key:String, replace:String = "normal"):void;
		function get current():String;
		//是否可用
		function setEnabled(value:Boolean):void;
		function get enabled():Boolean;
		//点击执行
		function set clickHandler(touch:Function):void;
		//强制更新动作
		function updateAction():void;
		//取
		function getSwitcher(state:String):*;
		//end
	}
	
}