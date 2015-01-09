package org.web.sdk.handler 
{
	public class Observer 
	{
		private var target:Object;
		private var called:Function;
		private var valid:Boolean;
		private var data:Object;
		
		public function Observer(target:Object, called:Function, data:Object = null) 
		{
			this.target = target;
			this.called = called;
			this.data = data;
			this.valid = true;
		}
		
		public function match(value:Object):Boolean
		{
			return target === value;
		}
		
		public function get handler():Function
		{
			return this.called;
		}
		
		public function isValid():Boolean
		{
			return this.valid;
		}
		
		public function getBody():Object
		{
			return this.data;
		}
		
		public function destroy():void
		{
			this.valid = false;
			this.target = null;
			this.called = null;
		}
		
		public function dispatch(event:Array):void
		{
			if (!this.valid) return;
			called.apply(target, event);
		}
		
		//ends
	}

}