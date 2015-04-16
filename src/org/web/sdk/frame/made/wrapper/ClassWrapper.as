package org.web.sdk.frame.made.wrapper 
{
	import org.web.sdk.frame.made.interfaces.ICommand;
	import org.web.sdk.frame.made.interfaces.IWrapper;
	
	public class ClassWrapper implements IWrapper 
	{
		private var _target:Class;
		private var _live:Boolean;
		private var _type:int;
		private var _name:String;
		
		public function ClassWrapper(target:Class, name:String, type:int = 0) 
		{
			this._target = target;
			this._name = name;
			this._type = type;
			this._live = true;
		}
		
		public function match(value:Object):Boolean
		{
			return _target === value;
		}
		
		public function isLive():Boolean
		{
			return this._live;
		}
		
		public function destroy():void
		{
			this._live = false;
			this._target = null;
		}
		
		public function handler(event:Object):void
		{
			if (this._live) {
				var command:ICommand = new _target;
				command.execute(_name, event);
			}
		}
		
		public function toString():String
		{
			return "{ target=" + _target + ", type=" + _type+", islife=" + _live+"}";
		}
		//ends
	}

}