package org.web.sdk.net.socket 
{
	import org.web.sdk.log.Log;
	import org.web.sdk.net.socket.inter.ISocketRespond;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.GlobalMessage;
	/*
	 * 转换器
	 * */
	public class RespondConverter 
	{
		public var cmd:int;
		public var className:Class;
		private var vector:Vector.<String> = null;
		
		public function RespondConverter(cmd:int, className:Class, list:Array = null) 
		{
			this.cmd = cmd;
			this.className = className;
			this.addNotice(list);
		}
		
		public function addNotice(list:Array):void
		{
			if (vector == null) vector = new Vector.<String>;
			for (var i:int = 0; i < list.length; i++) vector.push(list[i]);
		}
		
		public function free():void
		{
			if (null == vector) return;
			while (vector.length) vector.shift();
			vector = null;
		}
		
		public function handler(event:RespondEvented):void
		{
			Log.log(this).debug("->服务端推送命令:" + cmd, ',handler:', this);
			var respond:ISocketRespond = new className();
			respond.action(cmd, event);
			if (vector) {
				for (var i:int = 0; i < vector.length; i++) {
					GlobalMessage.sendMessage(vector[i], respond.getMessage(), null, Evented.SERVER_CALL_CLIENT);
				}
			}
		}
		
		//end
	}

}