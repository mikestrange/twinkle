package org.web.sdk.net.socket.handler 
{
	import org.web.sdk.net.events.RespondEvented;
	import org.web.sdk.net.socket.inter.ICmdHandler;
	import org.web.sdk.system.inter.IController;
	import org.web.sdk.utils.UniqueHash;
	
	public class CmdManager 
	{
		private static var modules:UniqueHash = new UniqueHash;
		
		//添加命令处理  ICmdHandler 尽量永久保存  至于ICmdHandler内部是怎么处理的我们不管
		public static function cmdHanlder(cmd:Number, handler:ICmdHandler, called:Function):void
		{
			if (!modules.isKey(cmd)) {
				modules.put(cmd, handler);
				handler.register();
			}
			handler.add(called);
		}
		
		public static function removeHander(cmd:Number, called:Function):void
		{
			var handler:ICmdHandler = modules.getValue(cmd);
			if (handler) {
				if (handler.remove(called)) {
					modules.remove(cmd);
					handler.destroy();
				}
			}
		}
		
		private static function getHandler(cmd:Number):ICmdHandler
		{
			return modules.getValue(cmd);
		}
		
		public static function handlerRespond(cmd:uint, event:RespondEvented = null):Boolean
		{
			var hanlder:ICmdHandler = getHandler(cmd);
			if (hanlder) hanlder.handler(cmd, event);
			return hanlder != null;
		}
		//ends
	}
}