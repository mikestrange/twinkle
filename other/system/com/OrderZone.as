package org.web.sdk.system.com 
{
	import org.web.sdk.system.events.Evented;
	
	/*
	 * 自身就是一个命令，只是作为一个中转站  没有人会关心他的存在
	 * */
	public class OrderZone implements ICommand 
	{
		public static const ON:int = 1;
		public static const OFF:int = 2;
		//
		private var _target:Object;		//这个命令是谁添加的
		private var _className:Class;
		private var _state:int = 0;
		
		public function OrderZone($target:Object, className:Class, state:int = 1) 
		{
			_target = $target;
			_className = className;
			_state = state;
		}
		
		//匹配注册者
		public function match(value:Object):Boolean
		{
			return _target === value;
		}
		
		//执行命令
		public function execute(event:Evented):void
		{
			if (isClosed()) return;
			var command:ICommand = new _className;
			command.execute(event);
		}
		
		//状态
		public function set state(value:int):void
		{
			this._state = value;
		}
		
		public function get state():int 
		{
			return _state;
		}
		
		//是否开放
		public function isOpen():Boolean
		{
			return _state == ON;
		}
		
		//是否关闭了
		public function isClosed():Boolean
		{
			return _state == OFF;
		}
		
		//ends
	}

}