package org.web.sdk.system.key 
{
	public class KeyRequest 
	{
		private var _down:Function;
		private var _up:Function;
		private var _name:String;
		
		//一个按键标记
		public function KeyRequest(mark:String, downFun:Function, upFun:Function) 
		{
			_name = mark;
			_down = downFun;
			_up = upFun;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function free():void
		{
			_down = null;
			_up = null;
		}
		
		public function respondDown(action:KeyAction):void
		{
			if (_down is Function) _down(_name, action);
		}
		
		public function respondUp(action:KeyAction):void
		{
			if (_up is Function) _up(_name, action);
		}
		//ends
	}

}