package org.web.sdk.admin 
{
	import flash.utils.Dictionary;
	import org.web.sdk.interfaces.rest.IWindow;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 界面管理
	 */
	final public class PopupManager
	{
		private static var winList:Vector.<String> = new Vector.<String>;
		private static var winMap:Dictionary = new Dictionary;
		
		//是否显示
		public static function hasWindows(name:String):Boolean
		{
			return winMap[name] != undefined;
		}
		
		//显示并且注册
		public static function showRegister(target:IWindow, data:Object = null):void
		{
			const name:String = target.getDefineName();
			//同名关闭
			close(name);
			//注册
			winList.push(name);
			winMap[name] = target;
			//show
			target.show(data);
		}
		
		//这里可以在任何地方调用
		public static function close(name:String = null):IWindow
		{
			if (!hasWindows(name)) return null;
			var win:IWindow = getWindows(name);
			deletes(name);
			win.closed();
			return win;
		}
		
		public static function closeCurrent():IWindow
		{
			if (winList.length) {
				return close(winList[winList.length - 1]);
			}
			return null;
		}
		
		//这个由窗口内部调用
		public static function unRegister(target:IWindow):void
		{
			const name:String = target.getDefineName();
			if (!hasWindows(name)) return;
			deletes(name);
		}
		
		//刷新视图，不存在就不刷新
		public static function update(name:String, data:Object = null):void
		{
			if (!hasWindows(name)) return;
			getWindows(name).update(data);
		}
		
		//---必定存在
		private static function deletes(name:String):void
		{
			delete winMap[name];
			const index:int = winList.indexOf(name);
			if (index != -1) winList.splice(index, 1);
		}
		
		//清理所有
		public static function cleanPopups():void
		{
			trace("#关闭所有窗口");
			for each(var win:IWindow in winMap)
			{
				win.closed();
			}
		}
		
		protected static function getWindows(name:String):IWindow
		{
			return winMap[name];
		}
		
		public static function toString():void
		{
			trace("-----------popup start---------------")
			trace("--------win list:", winList);
			trace("----->maps:\n")
			for (var key:String in winMap) {
				trace("->key=", key, ", value = ", winMap[key]);
			}
			trace("----------end------------")
		}
		//
	}

}