package org.web.sdk.admin 
{
	import org.web.sdk.display.base.AppDirector;
	import org.web.sdk.global.HashMap;
	import org.web.sdk.interfaces.rest.IWindow;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 界面管理
	 */
	final public class PopupManager extends HashMap 
	{
		private static var _ins:PopupManager;
		
		private var nameList:Vector.<String>;
		private var winMap:HashMap;
		
		private static function gets():PopupManager
		{
			if (null == _ins) _ins = new PopupManager;
			return _ins;
		}
		
		public function PopupManager()
		{
			//winMap = new HashMap;
			//nameList = new Vector.<String>;
		}
		
		//是否显示
		public static function has(name:String):Boolean
		{
			return gets().isKey(name);
		}
		
		//不初始化
		public static function show(target:IWindow, data:Object = null):void
		{
			const name:String = target.getDefineName();
			close(name);
			gets().put(name, target);
			trace("#显示窗口:", name);
			target.show(data);
		}
		
		//最后一个参数，是否直接移除
		public static function close(name:String):void
		{
			var win:IWindow = gets().remove(name);
			if (win) {
				trace("#关闭窗口:", name);
				win.closed();
			}
		}
		
		//这里只是移除，删除后就变成了游离窗口
		public static function remove(name:String):IWindow
		{
			return gets().remove(name);
		}
		
		//刷新视图，不存在就不刷新
		public static function update(name:String, data:Object = null):void
		{
			var win:IWindow = gets().getValue(name);
			if (win) {
				trace("#刷新窗口", name);
				win.update(data);
			}
		}
		
		//清理所有
		public static function clean():void
		{
			trace("#关闭所有窗口");
			gets().eachKey(close);
		}
		
		//批量执行
		public static function eachfor(handler:Function):void
		{
			gets().eachValue(handler);
		}
		
		//
	}

}