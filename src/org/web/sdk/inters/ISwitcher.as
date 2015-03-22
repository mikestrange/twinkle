package org.web.sdk.inters 
{
	//切换器
	public interface ISwitcher 
	{
		function defineAction(key:String, target:*= undefined):void;
		function setNormal(target:*):void;
		function setCurrent(key:String, replace:String = "normal"):void;
		function get current():String;
		function setEnabled(value:Boolean):void;
		function get enabled():Boolean;
		function setProvoke(touch:Function):void;
		function forEach():void;
		//end
	}
	
}