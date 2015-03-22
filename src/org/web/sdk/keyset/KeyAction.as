package org.web.sdk.keyset 
{
	import flash.utils.*;

	public class KeyAction 
	{
		public var downTime:Number;
		public var upTime:Number;
		//
		private var _requestList:Dictionary
		private var _code:uint;
		private var _isdown:Boolean = false;
		private var _size:int = 0;
		
		public function KeyAction(codes:uint) 
		{
			_code = codes;
			_requestList = new Dictionary;
		}
		
		public function get code():uint
		{
			return _code;
		}
		
		public function isDown():Boolean
		{
			return _isdown;
		}
		
		public function isUp():Boolean
		{
			return !_isdown;
		}
		
		public function setLoosen():void
		{
			_isdown = false;
		}
		
		public function update(value:Boolean):void
		{
			var request:KeyRequest;
			if (value) {
				if (!_isdown) {
					_isdown = true;
					downTime = getTimer();
					for each(request in _requestList) request.respondDown(this);
				}
			}else {
				_isdown = false;
				upTime = getTimer();
				for each(request in _requestList) request.respondUp(this);
			}
		}
		
		public function add(request:KeyRequest):void
		{
			var name:String = request.name;
			if (_requestList[name] == null) 
			{
				_size++;
				_requestList[name] = request;
			}
		}
		
		public function has(name:String):Boolean
		{
			return _requestList[name] != null;
		}
		
		public function remove(name:String):void
		{
			var request:KeyRequest = _requestList[name];
			if (request) {
				_size--;
				delete _requestList[name];
				request.free();
			}
		}
		
		public function isEmpty():Boolean
		{
			return _size == 0;
		}
		
		public function clear():void
		{
			var name:String;
			var request:KeyRequest;
			for (name in _requestList) {
				request = _requestList[name];
				if (request) request.free();
				delete _requestList[name];
			}
			_size = 0;
		}
		
		//从点击到松开的时间
		public function get loopback():Number
		{
			return upTime - downTime;
		}
		
		//ends
	}

}

