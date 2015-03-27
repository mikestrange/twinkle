package org.web.sdk.keyset 
{
	import flash.net.URLRequest;
	import flash.utils.*;
	import flash.events.KeyboardEvent;
	import org.web.sdk.Mentor;
	
	public class KeyManager 
	{
		//
		private static var keyCodes:Dictionary = new Dictionary;
		private static var _ins:KeyManager;
		
		public static function gets(value:Boolean = true):KeyManager
		{
			if (null == _ins) _ins = new KeyManager;
			_ins.enable = value;
			return _ins;
		}
		
		public function set enable(value:Boolean):void
		{
			Mentor.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownCall);
			Mentor.stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpCall);
			if (value) {
				Mentor.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownCall);
				Mentor.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpCall);
			}
		}
		
		protected function keyDownCall(e:KeyboardEvent):void
		{
			KeyManager.sendKeyMessage(e.keyCode, true);
		}
		
		protected function keyUpCall(e:KeyboardEvent):void
		{
			KeyManager.sendKeyMessage(e.keyCode, false);
		}
			
		//也可以主动调用
		public static function sendKeyMessage(code:uint, value:Boolean):void
		{
			var action:KeyAction = KeyManager.getKey(code);
			if (action) action.update(value);
		}
		
		//listener  是否有喘息的机会
		public static function keyListener(code:uint, mark:String, downFun:Function, upFun:Function = null):void
		{
			var action:KeyAction = getKey(code);
			if (null == action) {
				action = new KeyAction(code);
				keyCodes[code] = action;
			}
			action.add(new KeyRequest(mark, downFun, upFun));
		}
		
		protected static function getKey(code:uint):KeyAction
		{
			return keyCodes[code];
		}
		
		public static function isKeyDown(code:uint):Boolean
		{
			var action:KeyAction = getKey(code);
			if (action) return action.isDown();
			return false;
		}
		
		public static function loosenKeys():void
		{
			for (var code:* in keyCodes) {
				var action:KeyAction = getKey(code);
				if (action) action.setLoosen();
			}
		}
		
		//remove
		public static function removeKey(code:uint, mark:String):void
		{
			var action:KeyAction = getKey(code);
			if (action) {
				action.remove(mark);
				if (action.isEmpty()) {
					delete keyCodes[code]; 
				}
			}
		}
		
		public static function releaseAll(code:int = -1):void
		{
			if (code == -1) {
				for (var value:* in keyCodes) releaseAll(value);
			}else {
				var action:KeyAction = getKey(code);
				if (action) {
					delete keyCodes[code]; 
					action.clear();
				}
			}
		}
		
		//ends
	}
}


