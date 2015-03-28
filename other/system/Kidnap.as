package org.web.sdk.system 
{
	import org.web.sdk.net.socket.AssignedTransfer;
	import org.web.sdk.net.socket.ServerSocket;
	import org.web.sdk.system.GlobalMessage;
	import org.web.sdk.log.Log;
	import org.web.sdk.system.com.*;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.inter.*;
	import org.web.sdk.utils.HashMap;

	/*
	 * 和puerMvc基本一样
	 * 天网,所有模块和命令都是在天网中布置的
	 * */
	public class Kidnap implements IKidnap
	{
		private static var _ins:Kidnap;
		
		public static function gets():IKidnap
		{
			if (null == _ins) _ins = new Kidnap;
			return _ins;
		}
		
		/*
		 * 注意，不要把自身添加在自己的模板中
		 * */
		private var _controHash:HashMap;
		private var _message:IMessage;
		
		public function Kidnap() 
		{
			_controHash = new HashMap; 	
		}
		
		//添加自身监听 []
		protected function addMessage(name:String, called:Function):void
		{
			_message.addMessage(name, called);
		}
		
		//删除自身 []
		protected function removeMessage(name:String, called:Function):void
		{
			_message.removeMessage(name, called);
		}
		
		/* INTERFACE org.web.sdk.system.inter.IKidnap */
		/*
		 * 一般情况不会调用
		 * */
		public function sendLink(...events):void
		{
			for (var i:int = 0; i < events.length; i++) execute(events[i]);
		}
		
		//通知类型 可以执行的[String,Evented,ICommand,Class]
		protected function execute(item:*):void
		{
			if (item is String) {
				_message.sendMessage(item as String);
			}else if (item is Evented) {
				_message.sendMessage(item.name, item.data, item.client);
			}else if (item is ICommand) {	
				//这个算单独执行
				ICommand(item).execute(null);
			}else if (item is Class) {
				//这个算单独执行
				var command:ICommand = new item;
				command.execute(null);
			}
		}
		
		/*
		 * 发送事件
		 */
		public function sendMessage(newName:String, data:Object = null, client:* = undefined):void 
		{
			_message.sendMessage(newName, data, client, Evented.CLIENT_MESSAGE);
		}
		
		/*
		 * 添加一个模块   所有模块他管理
		 * */
		public function addController(controller:IController):Boolean 
		{
			var name:String = controller.getName();
			if (!isController(name)) {
				_controHash.put(name, controller);
				addMessageFromController(controller);	//先添加命令
				controller.launch(getMessage());
				Log.log(this).debug('#添加模块->', controller,', 感兴趣事件->',controller.getSecretlyNotices());
				return true;
			}
			return false;
		}
		
		private function addMessageFromController(controller:IController):void
		{
			var newList:Array = controller.getSecretlyNotices();
			for (var i:int = 0; i < newList.length; i++) {
				addMessage(newList[i], controller.dutyEvented);
			}
		}
		
		//
		public function isController(name:String):Boolean 
		{
			return _controHash.isKey(name);
		}
		
		/*
		 * 释放模块
		 * */
		public function disController(name:String):IController 
		{
			var cont:IController = _controHash.remove(name);
			if (cont) {
				Log.log(this).debug('#删除模块->', cont);
				removeMessageFromController(cont);	//先删除命令
				cont.free();						//释放
			}
			return cont;
		}
		
		private function removeMessageFromController(controller:IController):void
		{
			var newList:Array = controller.getSecretlyNotices();
			for (var i:int = 0; i < newList.length; i++) {
				removeMessage(newList[i], controller.dutyEvented);
			}
		}
		
		/*
		 * 注入的全局事件
		 * */
		public function getMessage():IMessage 
		{
			return _message;
		}
		
		/*
		 * 偷偷的通知
		 * */
		public function getSecretlyNotices():Array 
		{
			return ['None'];
		}
		
		public function getName():String 
		{
			return null;
		}
		
		/*
		 * 默认了一个启动全局事件
		 * */
		public function launch(notice:IMessage):void
		{
			
		}
		
		//开始需要一个消息机制
		public function start(notice:IMessage = null):void
		{
			Log.log(this).debug("#启动天网");
			_message = notice == null ? GlobalMessage.gets() : notice;
			addMessageFromController(this);
			launch(_message);
			//socket建立
			ServerSocket.create(new AssignedTransfer);
		}
		
		/*
		 * 释放所有模块
		 * */
		public function free():void 
		{
			Log.log(this).debug("#释放天网");
			//移除自身命令监听
			removeMessageFromController(this);
			//删除模块
			_controHash.eachKey(disController);
		}
		
		/*
		 * 自身责任通知
		 * */
		public function dutyEvented(event:Evented):void 
		{
			
		}
		//ends
	}

}