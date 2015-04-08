package org.web.sdk.frame.core 
{
	import flash.utils.Dictionary;
	import org.web.sdk.frame.interfaces.IDataTable;
	import org.web.sdk.frame.interfaces.IVent;
	/*
	 * 通道
	 * */
	public class Vetted implements IVent 
	{
		private var _tableList:Vector.<IDataTable>;
		
		public function Vetted()
		{
			_tableList = new Vector.<IDataTable>;
		}
		
		/* INTERFACE org.web.sdk.frame.interfaces.IVent */
		/*
		 * 实现公开的方法就可以了
		 * */
		public function invoke(method:String, data:Object = null, client:* = undefined):void 
		{
			//必须接受两个参数
			if (this.hasOwnProperty(method)) 
			{
				this[method](data, client);
			}
		}
		
		public function register(name:String):IDataTable
		{
			var table:IDataTable = createTable(name);
			if (table) _tableList.push(table);
			return table;
		}
		
		public function destroy(table:IDataTable):void 
		{
			var index:int = _tableList.indexOf(table);
			if (index != -1) {
				_tableList.splice(index, 1);
			}
		}
		
		public function isEmpty():Boolean
		{
			return _tableList.length == 0;
		}
		
		//----快速建立数据表
		protected function createTable(tableName:String):IDataTable 
		{
			return null;
		}
		//end
	}

}