package org.web.sdk.admin 
{
	import org.web.sdk.interfaces.rest.ITips;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 小贴士管理
	 */
	public class TipsManager 
	{
		private var list:Vector.<ITips>
		
		public function TipsManager() 
		{
			list = new Vector.<ITips>;
		}
		
		//设置不同类型的tips
		public function push(tips:ITips, data:Object = null, type:int = 0):void
		{
			list.push(tips);
			trace("#显示tips", tips);
			tips.show(type, data);
		}
		
		//需要本身来调用，外界不管 tips.removeFromAdmin 必须调用,也只需要调用它就可以了
		public function remove(tips:ITips):void
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
				if (list[i].type == type) {
					handler(list[i]);
				}
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
		private static var _ins:TipsManager;
		
		public static function gets():TipsManager
		{
			if (null == _ins) _ins = new TipsManager;
			return _ins;
		}
		
		//end
	}

}