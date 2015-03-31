package org.web.sdk.fot.interfaces 
{
	import org.web.sdk.fot.core.Container;
	/*
	 * 应用监听
	 * */
	public interface IApplicationListener 
	{
		//
		function sendMessage(name:String, event:Object = null):void;
		//
		function sendLink(data:Object = null, ...rest):void;
		//固定
		function sendWater(name:String, ...rest):void;
		
		//public add / remove
		function addCommand(name:String, className:Class):void;
		
		function removeCommand(name:String, className:Class):void;
		
		function addMethod(name:String, called:Function):void;
		
		function removeMethod(name:String, called:Function):void;
		
		//
		function clearWrapper():void;
		
		//这里是生成监视器给别人
		function createContainer(name:String):Container;
		
		function removeContainer(name:String):void;
		
		//end
	}
	
}