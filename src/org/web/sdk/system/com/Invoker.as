package org.web.sdk.system.com 
{
	import flash.utils.Dictionary;
	import org.web.sdk.log.Log;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.inter.IKidnap;
	import org.web.sdk.system.inter.IMessage;
	import org.web.sdk.system.Kidnap;
	import org.web.sdk.utils.HashMap;
	import org.web.sdk.utils.NameUtil;
	
	/*
	 * 所有命令管理需要继承他
	 * 命令执行区域，命令和事件不兼容
	 * */
	public class Invoker 
	{
		private static var _ins:Invoker;
		
		public static function gets():Invoker
		{
			if (null == _ins) _ins = new Invoker;
			return _ins;
		}
		
		//命令管理[自身不能显示的改变命令的注册和删除]
		private var commandHash:HashMap;
		private var message:IMessage;
		
		public function Invoker(msg:IMessage = null) 
		{
			commandHash = new HashMap;
			if(msg) register(msg);
		}
		
		/*
		 * 你只需要在乎命令的注册
		 * 建立所有的命令机制  【自身建立和摧毁命令】不必对外公开
		 */
		public function register(msg:IMessage):void
		{
			this.message = msg;
		}
		
		/*
		 * 封装好了的命令清理，退出清除自身所有命令,不需要自己去清理
		 * */
		public function quit():void
		{
			if (this.message == null) return;
			commandHash.eachKey(removeCommand);
			this.message = null;
		}
		
		/*
		 * 一条指令添加一条命令 ,在某个地方添加就不会重复添加了
		 * */
		public function addOnlyCommand(newName:String, className:Class):Boolean
		{
			if (commandHash.isKey(newName)) return false;
			Log.log(this).debug("#添加命令 [ name =", newName, " , className =", NameUtil.getClassName(className), "]");
			commandHash.put(newName, new OrderZone(this, className));
			//注册一个监听事务
			message.addMessage(newName, execute);
			return true;
		}
		
		/*
		 * 移除命令   [由自身建立,只有自身才能移除，其他人不能移除]
		 * */
		public function removeCommand(newName:String):Boolean
		{
			var order:OrderZone = commandHash.getValue(newName);
			if (order && order.match(this)) {
				Log.log(this).debug("#删除命令 [ name =", newName, ', from =', NameUtil.getClassName(this), "]");
				//删除回调监听事务
				message.removeMessage(newName, execute);
				return commandHash.remove(newName) != null;
			}
			return false;
		}
		
		/*
		 * 设置命令状态  默认开放
		 * */
		public function setAction(name:String, value:int = 1):void
		{
			var order:OrderZone = commandHash.getValue(name);
			if (order) order.state = value;
		}
		
		/*
		 * 返回状态
		 * */
		public function getAction(name:String):int
		{
			var order:OrderZone = commandHash.getValue(name);
			if (order) return order.state;
			return -1;
		}
		
		/*
		 * 执行命令   如果你不想添加额外的工作，那么所有的事务都可以写在这里
		 * */
		protected function execute(event:Evented):void
		{
			var order:ICommand = commandHash.getValue(event.name);	//order is OrderZone
			if (order) order.execute(event);
		}
		//
	}
}