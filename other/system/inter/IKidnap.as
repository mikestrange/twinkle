package org.web.sdk.system.inter 
{
	/*
	 * 天网肯定包含了模块数据和模块视图
	 * */
	public interface IKidnap extends IController 
	{
		function sendLink(...events):void;
		function sendMessage(newName:String, data:Object = null, client:*= undefined):void;
		function addController(controller:IController):Boolean;
		function isController(name:String):Boolean;
		function disController(name:String):IController;
		function getMessage():IMessage;
		//ends
	}
	
}