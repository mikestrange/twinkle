package org.web.sdk.admin 
{
	import org.web.sdk.interfaces.rest.IAlert;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 小贴士管理
	 */
	public class AlertManager 
	{
		private var list:Vector.<IAlert>
		
		public function AlertManager() 
		{
			list = new Vector.<IAlert>;
		}
		
		//设置不同类型的tips
		public function push(tips:IAlert, data:Object = null, type:int = 0):void
		{
			list.push(tips);
			trace("#显示tips", tips);
			tips.show(type, data);
		}
		
		//需要本身来调用，外界不管 tips.removeFromAdmin 必须调用,也只需要调用它就可以了
		public function remove(tips:IAlert):void
		{
			var index:int = list.indexOf(tips);
			if (index != -1) {
				list.splice(index, 1);
				trace("#移除tips", tips);
				tips.hide();
			}
		}
		
		//批量执行tips, PS:如果使用删除，最好不要用次方法,
		public function eachfor(handler:Function, type:int = 0):void
		{
			for (var i:int = list.length - 1; i >= 0; i--) 
			{
				if (list[i].type == type) handler(list[i]);
			}
		}
		
		//关闭所有
		public function clean():void
		{
			while (list.length) {
				list.shift().hide(); //这里只是关闭显示
			}
		}
		
		//
		private static var _ins:AlertManager;
		
		public static function gets():AlertManager
		{
			if (null == _ins) _ins = new AlertManager;
			return _ins;
		}
		
		//end
	}

}