package org.web.sdk.frame.interfaces 
{
	import org.web.sdk.fot.interfaces.IApplicationListener;
	/**
	 * 客服中心，他只对数据表和逻辑中心感兴趣
	 */
	public interface IClientServer 
	{
		function start(type:String, check:IVentManager = null):void;
		//添加模块
		function addController(logic:IController):void;
		function removeController(name:String):IController;
		//取数据表
		function getTable(name:String):IDataTable;
		//打开一个通道,如果不填写ventName那么他的名称就和数据表一样
		function openVent(tableName:String, ventName:String = null):IDataTable;
		//关闭一张数据表，通道有没有关闭我们不确定,可能某个模块也用到了
		function shutTable(tableName:String):void;
		//一个主要的监听器
		function getListener():IApplicationListener;
		//end
	}
	
}