package org.web.sdk.net.socket 
{
	import org.web.sdk.net.socket.base.FtpRead;
	import org.web.sdk.net.socket.inter.IRequest;
	import org.web.sdk.net.socket.inter.ISocketRespond;
	import org.web.sdk.utils.HashMap;
	import org.web.sdk.utils.NameUtil;
	/*
	 * 对socket的回执进行处理
	 * */
	public class SocketModule 
	{
		private static var hash_respond:HashMap = new HashMap;
		//
		private var _moduleType:int;
		private var cmdRespondList:Vector.<String>;
		private var _isRegister:Boolean = false;
		//
		public static const UINT:String = "0x";
		public static const LEN:int = 16;
		
		public function SocketModule(moduleType:int = 1) 
		{
			_moduleType = moduleType;
			cmdRespondList = new Vector.<String>;
			register();
		}
		
		//初始化
		public function register():Boolean
		{
			if (_isRegister) return false;
			_isRegister = true;
			about_register();
			return _isRegister;
		}
		
		//真正的注册
		protected function about_register():void
		{
			
		}
		
		public function isRegister():Boolean
		{
			return _isRegister;
		}
		
		//
		protected function addRespond(cmd:uint, respondName:Class):void
		{
			var key:String = match(cmd);
			//添加回执
			if (respondName) {
				trace("#添加回执: cmd=", cmd, respondName);
				if (SocketModule.hash_respond.isKey(key)) throw Error(key + ' 已经注册过的ISocketRespond' + NameUtil.getClassName(this));
				cmdRespondList.push(key);
				SocketModule.hash_respond.put(key, respondName);
			}
		}
		
		//摧毁一个模块
		public function destroy():void
		{
			if (!_isRegister) return;
			_isRegister = false;
			while (cmdRespondList.length) {
				SocketModule.hash_respond.remove(cmdRespondList.shift());
			}
		}
		
		public static function match(cmd:uint):String
		{
			return UINT.concat(cmd.toString(LEN));
		}
			
		//取回执
		public static function createRespond(cmd:uint):ISocketRespond
		{
			var Respond:Class = SocketModule.hash_respond.getValue(match(cmd)) as Class;
			if (Respond) return new Respond as ISocketRespond;
			return null;
		}
		//ends
	}

}