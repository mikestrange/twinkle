package org.web.sdk.system.core 
{
	import org.web.sdk.handler.EventedDispatcher;
	import org.web.sdk.system.com.Invoker;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.inter.IMessage;
	import org.web.sdk.utils.HashMap;

	public class BaseMessage implements IMessage
	{
		/*
		 * 不仅可以添加事件，也能添加命令的接口
		 * 可以添加命令的接口
		 * */
		private var _dispatcher:EventedDispatcher;
		private var _hashInvoker:HashMap;
		
		public function BaseMessage()
		{
			_hashInvoker = new HashMap;
			_dispatcher = new EventedDispatcher;
		}
		
		/*
		 * 添加命令
		 * */
		public function addInvoker(name:String, invoker:Invoker):Boolean 
		{
			if (isInvoker(name)) return false;
			_hashInvoker.put(name, invoker);
			invoker.register(this);
			return true;
		}
		
		public function isInvoker(name:String):Boolean
		{
			return _hashInvoker.isKey(name);
		}
		
		public function removeInvoker(name:String):Boolean
		{
			var invoker:Invoker = _hashInvoker.remove(name);
			if (invoker) {
				invokerQuit(invoker);
				return true;
			}
			return false;
		}
		
		//释放所有命令
		public function eachQuitInvoker():void
		{
			_hashInvoker.eachValue(invokerQuit);
		}
		
		private function invokerQuit(invoker:Invoker):void
		{
			invoker.quit();
		}
		
		/* INTERFACE org.web.sdk.system.inter.IZclient */
		public function addMessage(name:String, called:Function):void 
		{
			_dispatcher.addNotice(name, called);
		}
		
		public function removeMessage(name:String, called:Function):void 
		{
			_dispatcher.removeNotice(name, called);
		}
		
		public function isMessage(name:String):Boolean
		{
			return _dispatcher.isset(name);
		}
		
		public function removeLink(name:String = null):void 
		{
			_dispatcher.removeLink(name);
		}
		
		public function sendBody(name:String, body:Object = null):void 
		{
			_dispatcher.dispatchNotice(name, body);
		}
		
		public function sendMessage(name:String, data:Object = null, client:*= undefined, type:uint = 0):void 
		{
			_dispatcher.dispatchNotice(name, new Evented(name, data, client, type));
		}
		//ends
	}
}