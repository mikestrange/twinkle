package org.web.sdk.frame.made.wrapper 
{
	import org.web.sdk.frame.made.interfaces.IWrapper;
	import org.web.sdk.frame.made.interfaces.IRoutine;
	
	public class MixtureWrapper implements IWrapper 
	{
		private var _target:IRoutine;
		private var _live:Boolean;
		private var _type:int;
		private var _name:String;
		
		public function MixtureWrapper(target:IRoutine, name:String, type:int = 0) 
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
			if (this._live) _target.tickEvent(_name, event);
		}
		
		public function toString():String
		{
			return "{ target=" + _target + ", type=" + _type+", islife=" + _live+"}";
		}
		//ends
	}

}