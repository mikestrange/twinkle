package org.web.sdk.admin 
{
	import org.web.sdk.global.HashMap;
	import org.web.sdk.interfaces.rest.IPanel;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 界面管理
	 */
	final public class WinManager extends HashMap 
	{
		private static var _ins:WinManager;
		
		private static function gets():WinManager
		{
			if (null == _ins) _ins = new WinManager;
			return _ins;
		}
		
		//是否显示
		public static function has(name:String):Boolean
		{
			return gets().isKey(name);
		}
		
		//不初始化
		public static function show(name:String, panel:IPanel, data:Object = null):void
		{
			if (has(name)) return;
			gets().put(name, panel);
			trace("#显示窗口", name);
			panel.onEnter(data);
		}
		
		//最后一个参数，是否直接移除
		public static function exit(name:String, direct:Boolean = true):void
		{
			var panel:IPanel = gets().remove(name);
			if (panel) {
				trace("#关闭窗口", name);
				panel.onExit(direct);
			}
		}
		
		//刷新视图，不存在就不刷新
		public static function update(name:String, data:Object = null):void
		{
			var panel:IPanel = gets().getValue(name);
			if (panel) {
				trace("#刷新窗口", name);
				panel.update(data);
			}
		}
		
		//清理所有
		public static function clean():void
		{
			trace("#关闭所有窗口");
			gets().eachKey(exit);
		}
		
		//批量执行
		public static function eachfor(handler:Function):void
		{
			gets().eachValue(handler);
		}
		
		//
	}

}