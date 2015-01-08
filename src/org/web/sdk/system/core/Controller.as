package org.web.sdk.system.core 
{
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.inter.IController;
	import org.web.sdk.system.inter.IKidnap;
	import org.web.sdk.system.inter.IMessage;
	import org.web.sdk.system.Kidnap;
	import org.web.sdk.utils.NameUtil;
	/*
	 * 逻辑主导模块并不需要关心自己处在的模块和其他模块之间的联系
	 * 他的在乎是自身的消息管理和消息的派发
	 * */
	public class Controller implements IController 
	{
		/*
		 * 每个模块的逻辑部分
		 * */
		private var _message:IMessage;
		
		public function Controller() 
		{
			initialization();
		}
		
		protected function initialization():void
		{
			
		}
		
		//自身还是保持对消息的持有
		protected function getMessage():IMessage
		{
			return _message;
		}
		
		/* INTERFACE org.web.sdk.system.inter.IController */
		/*
		 * 模块的名称
		 * */
		public function getName():String
		{
			return NameUtil.getClassName(this);
		}
		
		/*
		 * 感兴趣的消息
		 * */
		public function getSecretlyNotices():Array
		{
			return [];	
		}
		
		/*
		 * 启动调用,这里通知你一个命令机制
		 * */
		public function launch(notice:IMessage):void 
		{
			_message = notice;
		}
		
		/*
		 * 释放调用
		 * */
		public function free():void 
		{
			
		}
		
		/*
		 * 责任
		 * */
		public function dutyEvented(event:Evented):void
		{
			trace(event);
		}
		
		public function toString():String
		{
			return "[" + NameUtil.getClassName(this) + "] info={ name:" + this.getName() + "}";
		}
		
		//ends
	}

}