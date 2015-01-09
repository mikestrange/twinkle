package org.web.sdk.net.socket.handler 
{
	import org.web.sdk.handler.Observer;
	import org.web.sdk.log.Log;
	import org.web.sdk.net.socket.handler.RespondEvented;
	import org.web.sdk.net.socket.inter.ICmdConverter;
	import org.web.sdk.system.inter.IController;
	import org.web.sdk.utils.UniqueHash;
	
	public class CmdManager 
	{
		private static var modules:UniqueHash = new UniqueHash;
		private static const NONE:int = 0;
		
		//一个命令一个处理
		public static function cmdHanlder(cmd:Number, called:Function, target:Object):void
		{
			var vector:Vector.<Observer> = modules.getValue(cmd);
			if (null == vector) {
				vector = new Vector.<Observer>
				modules.put(cmd, vector);
			}
			vector.push(new Observer(target, called));
		}
		
		public static function removeHandler(cmd:Number, called:Function, target:Object):void
		{
			var vector:Vector.<Observer> = modules.getValue(cmd);
			if (vector) {
				for (var i:int = vector.length - 1; i >= NONE; i--) {
					if (vector[i].match(target) && vector[i].handler == called) {
						vector[i].destroy();
						vector.splice(i, 1);
						break;
					}
				}
				if (vector.length == NONE) modules.remove(cmd);
			}
		}
		
		//处理socket事务
		public static function dispatchRespond(event:RespondEvented):Boolean
		{
			var cmd:Number = event.getCmd();
			var vector:Vector.<Observer> = modules.getValue(cmd);
			if (vector) {
				Log.log().debug("->server :cmd" + cmd);
				var list:Vector.<Observer> = vector.slice(NONE, vector.length);
				for (var index:int = NONE; index < list.length; index++) {
					list[index].dispatch([event]);
				}
				list = null;
			}
			return vector != null;
		}
		//ends
	}
}