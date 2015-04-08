package org.web.sdk.fot.core 
{
	import flash.utils.Dictionary;
	import org.web.sdk.fot.interfaces.IRoutine;
	import org.web.sdk.fot.interfaces.IWrapper;
	import org.web.sdk.fot.tracker.Tracker;
	import org.web.sdk.fot.wrapper.ClassWrapper;
	import org.web.sdk.fot.wrapper.MethodWrapper;
	import org.web.sdk.fot.wrapper.MixtureWrapper;
	import org.web.sdk.fot.wrapper.TactVector;
	/*
	 *  [集装箱模式]
	 * 一个对象一个集装箱模式就够了
	 * 集装箱的目的是：一个类型名称只能保证一个派发机制
	 * */
	public class Container 
	{
		private var _tactList:Vector.<TactVector>;	//消息人
		private var _hash:Dictionary;				//单一消息
		private var _tracker:Tracker;
		
		public function Container(tracker:Tracker) 
		{
			_hash = new Dictionary;
			_tactList = new Vector.<TactVector>;
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
			removeAllTacter();
			for (var k:String in _hash) removeByName(k);
			_hash = new Dictionary;
		}
		
		//添加一个事务日常人
		public function addRoutine(target:IRoutine, ...parameter):void
		{
			var tacter:TactVector = indexOf(target);
			var v:Vector.<String> = tacter.getLinks();
			if (parameter.length) {
				if (v == null) v = new Vector.<String>;
				var name:String = null;
				for (var i:int = 0; i < parameter.length; i++) {
					name = parameter[i];
					var index:int = v.indexOf(name);
					if (index == -1) {
						v.push(name);
						addWrapper(name, new MixtureWrapper(target, name));
					}
				}
				tacter.setLinks(v);
			}
		}
		
		private function indexOf(value:IRoutine):TactVector
		{
			var tacter:TactVector = null;
			for (var i:int = _tactList.length - 1; i >= 0; i--) {
				tacter = _tactList[i];
				if (tacter.match(value)) return tacter;
			}
			tacter = new TactVector(value);
			_tactList.push(tacter);
			return tacter
		}
		
		//删除一个日常事务者
		public function removeRoutine(target:IRoutine):void
		{
			var tacter:TactVector = null;
			for (var i:int = _tactList.length - 1; i >= 0; i--) 
			{
				tacter = _tactList[i];
				if (tacter.match(target)) 
				{
					_tactList.splice(i, 1);
					removeTarget(tacter);
					break;
				}
			}
		}
		
		private function removeTarget(tacter:TactVector):void
		{
			var v:Vector.<String> = tacter.getLinks();
			if (v) {
				tacter.setLinks(null);
				for each(var str:String in v) {
					removeWrapper(str, tacter.target);
				}
			}
		}
		
		private function removeAllTacter():void
		{
			var tacter:TactVector = null;
			while (_tactList.length) {
				tacter = _tactList.shift();
				removeTarget(tacter);
			}
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

