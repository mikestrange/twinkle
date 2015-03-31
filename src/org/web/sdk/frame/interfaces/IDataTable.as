package org.web.sdk.frame.interfaces 
{
	/*
	 * 他对通道感兴趣
	 * -------
	 * 数据表知晓访问
	 * */
	public interface IDataTable 
	{
		function clean():void;
		function get ventName():String;
		function get tableName():String;
		function setMaster(ventter:IVent, ventName:String, tableName:String):void;
		function invoke(method:String, data:Object = null, client:*= undefined):void;
		//end
	}
	
}