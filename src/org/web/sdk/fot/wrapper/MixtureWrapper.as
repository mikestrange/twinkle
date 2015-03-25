package org.web.sdk.fot.wrapper 
{
	import org.web.sdk.fot.interfaces.IWrapper;
	import org.web.sdk.fot.interfaces.IMixture;
	
	public class MixtureWrapper implements IWrapper 
	{
		private var _target:IMixture;
		private var _live:Boolean;
		private var _type:int;
		private var _name:String;
		
		public function MixtureWrapper(target:IMixture, name:String, type:int = 0) 
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