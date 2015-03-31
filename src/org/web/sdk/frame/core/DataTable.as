package org.web.sdk.frame.core 
{
	import org.web.sdk.frame.interfaces.IDataTable;
	import org.web.sdk.frame.interfaces.IVent;
	
	public class DataTable implements IDataTable 
	{
		private var _tableName:String;
		private var _ventName:String;
		private var _ventter:IVent;
		
		/* INTERFACE org.web.sdk.frame.interfaces.IDataTable */
		public function get ventName():String 
		{
			return _ventName;
		}
		
		public function get tableName():String 
		{
			return _tableName;
		}
		
		//没有雇主就不能访问其方法
		public function setMaster(ventter:IVent, ventName:String, tableName:String):void
		{
			_ventter = ventter;
			_ventName = ventName;
			_tableName = tableName;
		}
		
		public function invoke(method:String, data:Object = null, client:*= undefined):void
		{
			if (_ventter) _ventter.invoke(method, data, client);
		}
		
		public function clean():void 
		{
			_ventter = null;
		}
		//end
	}

}