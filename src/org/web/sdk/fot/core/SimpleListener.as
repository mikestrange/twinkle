package org.web.sdk.fot.core 
{
	import flash.utils.Dictionary;
	import org.web.sdk.fot.interfaces.IApplicationListener;
	import org.web.sdk.fot.interfaces.IWrapper;
	import org.web.sdk.fot.wrapper.ClassWrapper;
	import org.web.sdk.fot.wrapper.MethodWrapper;
	import org.web.sdk.fot.tracker.Tracker;
	/**
	 * [普通监听模式/手动模式]
	 * 基础的事务添加和删除，非集装箱模式
	 */
	public class SimpleListener implements IApplicationListener
	{
		private var _content:Tracker;
		private var _contHash:Dictionary;
		
		public function SimpleListener(content:Tracker = null) 
		{
			_contHash = new Dictionary;
			if (content == null) _content = new Tracker;
			else this._content = content;
		}
		
		//protected
		protected function getTracker():Tracker
		{
			return _content;
		}
		
		protected function addWrapper(name:String, wrapper:IWrapper):void
		{
			_content.addListener(name, wrapper);
		}
		
		protected function removeWrapper(name:String, target:Object):void 
		{
			_content.removeListener(name, target);
		}
		
		//public send  不同的发送方式
		public function sendMessage(name:String, event:Object = null):void
		{
			_content.sendListener(name, event);
		}
		
		public function sendLink(data:Object = null, ...rest):void
		{
			for (var i:int = 0; i < rest.length; i++) {
				_content.sendListener(rest[i], data);
			}
		}
		
		//固定
		public function sendWater(name:String, ...rest):void
		{
			_content.sendListener(name, new Water(name, this, rest));
		}
		
		//public add / remove
		public function addCommand(name:String, className:Class):void
		{
			addWrapper(name, new ClassWrapper(className, name));
		}
		
		public function removeCommand(name:String, className:Class):void
		{
			removeWrapper(name, className);
		}
		
		public function addMethod(name:String, called:Function):void
		{
			addWrapper(name, new MethodWrapper(called, name));
		}
		
		public function removeMethod(name:String, called:Function):void
		{
			removeWrapper(name, called);
		}
		
		public function clearWrapper():void
		{
			_content.removeLink();
			for (var k:String in _contHash) removeContainer(k);
			_contHash = new Dictionary;
		}
		
		//这里是生成监视器给别人
		public function createContainer(name:String):Container
		{
			var container:Container = _contHash[name];
			if (container == null) new Container(getTracker());
			return container;
		}
		
		public function removeContainer(name:String):void
		{
			var container:Container = _contHash[name];
			if (container) {
				delete _contHash[name];
				container.clear();
			}
		}
		
		//end
	}

}