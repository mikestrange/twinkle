package org.web.sdk.net.socket 
{
	import org.web.sdk.log.Log;
	import org.web.sdk.utils.UniqueHash;
	/*
	 * 对socket的回执进行处理
	 * */
	public class SocketModule 
	{
		//所有回执添加
		private static var hash_respond:UniqueHash = new UniqueHash;
		//16进止转换
		private static const UINT:String = "0x";
		private static const LEN:int = 16;
		//
		private var _moduleType:int;
		private var cmdRespondList:Vector.<Number>;
		
		public function SocketModule(moduleType:int = 1) 
		{
			_moduleType = moduleType;
			cmdRespondList = new Vector.<Number>;
			register();
		}
		
		//初始化
		public function register():void
		{
			
		}
		
		//可以多添加
		public function addRespond(cmd:uint, respondName:Class, ...rest):void
		{
			if (null == respondName) throw Error("回调空");
			var respond:RespondConverter = hash_respond.getValue(cmd);
			if (null == respond) {
				respond = new RespondConverter(cmd, respondName, rest);
				hash_respond.put(cmd, respond);
				cmdRespondList.push(cmd);
			}
			respond.addNotice(rest);
		}
		
		//这个方法可以删除其他模块的,所以一般不用
		public function removeRespond(cmd:Number):void
		{
			var respond:RespondConverter = hash_respond.remove(cmd);
			if (respond) respond.free();
			var index:int = cmdRespondList.indexOf(cmd);
			if (index != -1) cmdRespondList.splice(index, 1);
		}
		
		//摧毁一个模块
		public function destroy():void
		{
			var respond:RespondConverter;
			while (cmdRespondList.length) {
				respond = hash_respond.remove(cmdRespondList.shift());
				if (respond) respond.free();
			}
		}
		
		//模板
		public static function match(cmd:uint):String
		{
			return UINT.concat(cmd.toString(LEN));
		}
		
		//当你直接调用handlerRespond  的时候那么就派发了所有CMD所关心的命令，并且把
		public static function handlerRespond(cmd:uint, event:RespondEvented = null):Boolean
		{
			var respond:RespondConverter = hash_respond.getValue(cmd);
			if (respond) respond.handler(event);
			return respond != null;
		}
		
		//ends
	}

}
