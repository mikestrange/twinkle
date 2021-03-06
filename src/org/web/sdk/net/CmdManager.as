package org.web.sdk.net 
{
	import org.web.sdk.log.Log;
	import org.web.sdk.net.interfaces.INetHandler;
	import org.web.sdk.net.RespondEvented;
	import org.web.sdk.global.MapInteger;
	/*
	 * 我们可以通过Type吧socket和http或者其他命令分开,也可以直接通过cmd分开
	 * */
	public class CmdManager 
	{
		private static var modules:MapInteger = new MapInteger;
		
		//一个命令一个处理
		public static function cmdHanlder(cmd:Number, handlerClass:Class):void
		{
			modules.put(cmd, handlerClass);
		}
		
		public static function removeHandler(cmd:Number):void
		{
			modules.remove(cmd);
		}
		
		//处理socket事务
		public static function respondHandler(event:RespondEvented):void
		{
			var HandClass:Class = modules.getValue(event.cmd);
			if (HandClass) {
				var result:INetHandler = new HandClass;
				result.netHandler(event);
			}else {
				Log.log().debug("#无法解析的命令：", event.cmd);
			}
		}
		//ends
	}
}