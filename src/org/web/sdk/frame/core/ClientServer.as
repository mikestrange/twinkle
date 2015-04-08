package org.web.sdk.frame.core 
{
	import flash.utils.Dictionary;
	import org.web.sdk.fot.core.SimpleListener;
	import org.web.sdk.fot.interfaces.IApplicationListener;
	import org.web.sdk.frame.interfaces.IClientServer;
	import org.web.sdk.frame.interfaces.IDataTable;
	import org.web.sdk.frame.interfaces.IController;
	import org.web.sdk.frame.interfaces.IVentManager;
	
	public class ClientServer implements IClientServer 
	{
		private var _logicMap:Dictionary;
		private var _tableMap:Dictionary;
		private var _check:IVentManager;
		private var _appListener:IApplicationListener;
		
		public function ClientServer(check:IVentManager, appListener:IApplicationListener = null) 
		{
			_logicMap = new Dictionary;
			_tableMap = new Dictionary;
			_check = check;
			if (appListener == null) appListener = new SimpleListener;
			_appListener = appListener;
		}
		
		/* INTERFACE org.web.sdk.frame.interfaces.IClientServer */
		public function start(type:String = null):void
		{
			
			
		}
		
		public function addController(controller:IController):void 
		{
			var name:String = controller.getName();
			if (_logicMap[name]) return;
			_logicMap[name] = controller;
			controller.launch();
		}
		
		public function removeController(name:String):IController 
		{
			var controller:IController = _logicMap[name];
			if (controller) {
				delete _logicMap[name];
				controller.free();
			}
			return controller;
		}
		
		public function getTable(name:String):IDataTable 
		{
			return _tableMap[name];
		}
		
		public function openVent(tableName:String, ventName:String = null):IDataTable 
		{
			var table:IDataTable = _tableMap[tableName];
			if (table) return table;
			if (_check) {
				if (ventName == null) ventName = tableName;
				table = _check.connect(ventName, tableName);
				if (table) {
					_tableMap[tableName] = table;
					trace("注册数据表和一个通道:", tableName, ventName);
				}
			}
			return table;
		}
		
		//关闭
		public function shutTable(tableName:String):void 
		{
			var table:IDataTable = _tableMap[tableName];
			if (table) {
				delete _tableMap[tableName];
				if (_check) _check.close(table);
				trace("删除一个数据表:", tableName);
			}
		}
		
		public function getListener():IApplicationListener 
		{
			return _appListener;
		}
		
		//end
	}

}