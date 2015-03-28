package org.web.sdk.system 
{
	import org.web.sdk.system.core.BaseMessage;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.inter.IMessage;
	
	/*定义一个全局的事件处理*/
	final public class GlobalMessage
	{
		public function GlobalMessage() { throw Error('do not new this class'); };
		
		private static var message:IMessage =  new BaseMessage;
		
		public static function gets():IMessage
		{
			return message;
		}
		
		//全局
		public static function addMessage(name:String, called:Function):void 
		{
			message.addMessage(name, called);
		}
		
		public static function removeMessage(name:String, called:Function):void 
		{
			message.removeMessage(name, called);
		}
		
		public static function isMessage(name:String):Boolean
		{
			return message.isMessage(name);
		}
		
		public static function removeLink(name:String = null):void 
		{
			message.removeLink(name);
		}
		
		public static function sendBody(name:String, body:Object = null):void 
		{
			message.sendBody(name, body);
		}
		
		public static function sendMessage(name:String, data:Object = null, client:*= undefined, type:uint = 0):void 
		{
			message.sendBody(name, new Evented(name, data, client, type));
		}
		//ends
	}
}