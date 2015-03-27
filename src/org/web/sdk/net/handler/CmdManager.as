package org.web.sdk.net.handler 
{
	import org.web.sdk.frame.observer.Observer;
	import org.web.sdk.log.Log;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.interfaces.IConverter;
	import org.web.sdk.system.inter.IController;
	import org.web.sdk.utils.UintHash;
	/*
	 * 我们可以通过Type吧socket和http或者其他命令分开,也可以直接通过cmd分开
	 * */
	public class CmdManager 
	{
		private static var modules:UintHash = new UintHash;
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
			var cmd:Number = event.cmd;
			var vector:Vector.<Observer> = modules.getValue(cmd);
			Log.log().debug("->server :cmd" + cmd, ",call:" + vector);
			if (vector) {
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