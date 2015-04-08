package org.web.sdk.frame.interfaces 
{
	
	/**
	 * 所有通道的集合
	 */
	public interface IVentManager 
	{
		function connect(ventName:String, tableName:String):IDataTable;
		function close(table:IDataTable):void;
		function setVentClass(name:String, className:Class = null):void;
		//end
	}
	
}