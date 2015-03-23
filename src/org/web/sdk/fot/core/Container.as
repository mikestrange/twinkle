package org.web.sdk.fot.core 
{
	import flash.utils.Dictionary;
	import org.web.sdk.fot.interfaces.IWrapper;
	import org.web.sdk.fot.tracker.Tracker;
	import org.web.sdk.fot.wrapper.ClassWrapper;
	import org.web.sdk.fot.wrapper.MethodWrapper;
	/*
	 *  [集装箱模式]
	 * 一个对象一个集装箱模式就够了
	 * 集装箱的目的是：一个类型名称只能保证一个派发机制
	 * */
	public class Container 
	{
		private var _hash:Dictionary;
		private var _tracker:Tracker;
		
		public function Container(tracker:Tracker) 
		{
			_hash = new Dictionary;
			register(tracker);
		}
		
		protected function register(tracker:Tracker):void
		{
			this._tracker = tracker;
		}
		
		//public add / remove
		public function addCommand(name:String, className:Class):void
		{
			if (_hash[name]) return;
			_hash[name] = className;
			addWrapper(name, new ClassWrapper(className, name));
		}
		
		public function addMethod(name:String, called:Function):void
		{
			if (_hash[name]) return;
			_hash[name] = called;
			addWrapper(name, new MethodWrapper(called, name));
		}
		
		public function addMethods(called:Function, ...rest):void
		{
			for (var i:int = 0; i < rest.length; i++) addMethod(rest[i], called);
		}
		
		public function removeByName(name:String):void
		{
			var t:Object = _hash[name];
			if (t) {
				delete _hash[name];
				removeWrapper(name, t);
			}
		}
		
		public function hasName(name:String):Boolean
		{
			return _hash[name] != undefined;
		}
		
		public function clear():void
		{
			for (var k:String in _hash) removeByName(k);
			_hash = new Dictionary;
		}
		
		//protected
		protected function addWrapper(name:String, wrapper:IWrapper):void
		{
			_tracker.addListener(name, wrapper);
		}
		
		protected function removeWrapper(name:String, target:Object):void 
		{
			_tracker.removeListener(name, target);
		}
		//
	}
}

