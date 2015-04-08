package org.web.sdk.fot.interfaces 
{
	/*
	 * 日常事务
	 * */
	public interface IRoutine 
	{
		//处理方法
		function tickEvent(name:String, event:Object = null):void;
		//end
	}
	
}