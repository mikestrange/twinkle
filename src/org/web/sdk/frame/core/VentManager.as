package org.web.sdk.frame.core 
{
	import flash.utils.Dictionary;
	import org.web.sdk.frame.interfaces.IDataTable;
	import org.web.sdk.frame.interfaces.IVent;
	import org.web.sdk.frame.interfaces.IVentManager;
	/*
	 * 通道管理器,唯一需要关系的模块之一
	 * */
	public class VentManager implements IVentManager 
	{
		private var _ventMap:Dictionary;
		private var _classMap:Dictionary;
		
		public function VentManager() 
		{
			_ventMap = new Dictionary;
			_classMap = new Dictionary;
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
			return new (_classMap[name] as Class);
		}
		
		//这里作为外部自定义添加
		public function setVentClass(name:String, className:Class = null):void
		{
			if (className == null) {
				if (_classMap[name]) {
					delete _classMap[name];
				}
			}else {
				_classMap[name] = className;
			}
		}
		
	}//end

}