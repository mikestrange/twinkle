package org.web.sdk.frame.core 
{
	import flash.utils.Dictionary;
	import org.web.sdk.frame.interfaces.IDataTable;
	import org.web.sdk.frame.interfaces.IVent;
	import org.web.sdk.frame.interfaces.IVentManager;
	
	public class VentManager implements IVentManager 
	{
		private var _ventMap:Dictionary;
		
		public function VentManager() 
		{
			_ventMap = new Dictionary;
		}
		
		/* INTERFACE org.web.sdk.frame.interfaces.IVentManager */
		final public function connect(ventName:String, tableName:String):IDataTable 
		{
			var ventter:IVent = _ventMap[ventName];
			if (ventter == null) {
				ventter = factoryVent(ventName);
				if (ventter == null) return null;
				_ventMap[ventName] = ventter;
			}
			var table:IDataTable = ventter.register(tableName);
			if (table == null) {
				if (ventter.isEmpty()) delete _ventMap[ventName];
			}else {
				table.setMaster(ventter, ventName, tableName);
			}
			return table;
		}
		
		//反向删除
		final public function close(table:IDataTable):void 
		{
			if (table) {
				var ventter:IVent = _ventMap[table.ventName];
				if (ventter) ventter.destroy(table);
				if (ventter.isEmpty()) {
					delete _ventMap[table.ventName];
				}
				table.clean();
			}
		}
		
		protected function factoryVent(name:String):IVent
		{
			return null;
		}
		
		
		
	}//end

}