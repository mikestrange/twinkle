package org.web.sdk.frame.core 
{
	import flash.utils.Dictionary;
	import org.web.sdk.frame.made.core.SimpleListener;
	import org.web.sdk.frame.made.interfaces.IApplicationListener;
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
		
		public function ClientServer(appListener:IApplicationListener = null) 
		{
			_logicMap = new Dictionary;
			_tableMap = new Dictionary;
			if (appListener == null) _appListener = new SimpleListener;
			else _appListener = appListener;
		}
		
		/* INTERFACE org.web.sdk.frame.interfaces.IClientServer */
		public function start(type:String):void
		{
			
		}
		
		public function getVentManager():IVentManager
		{
			if (null == _check) _check = new VentManager;
			return _check;
		}
		
		public function addController(controller:IController):void 
		{
			var name:String = controller.getName();
			if (_logicMap[name]) return;
			_logicMap[name] = controller;
			trace("#进入模块:", name);
			controller.launch();
		}
		
		public function removeController(name:String):IController 
		{
			var controller:IController = _logicMap[name];
			if (controller) {
				delete _logicMap[name];
				trace("#退出模块:", name);
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
			if (ventName == null) ventName = tableName;
			table = getVentManager().connect(ventName, tableName);
			if (table) {
				_tableMap[tableName] = table;
				trace("注册数据表和一个通道:", tableName, ventName);
			}
			return table;
		}
		
		//关闭
		public function shutTable(tableName:String):void 
		{
			var table:IDataTable = _tableMap[tableName];
			if (table) {
				delete _tableMap[tableName];
				getVentManager().close(table);
				trace("删除一个数据表:", tableName);
			}
		}
		
		//最强大的事件派发器
		public function getListener():IApplicationListener 
		{
			return _appListener;
		}
		
		//全局
		private static var _ins:IClientServer;
		
		public static function gets():IClientServer
		{
			if (_ins == null) _ins = new ClientServer;
			return _ins;
		}
		
		//end
	}

}