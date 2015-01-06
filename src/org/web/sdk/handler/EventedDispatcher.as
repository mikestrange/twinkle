package org.web.sdk.handler 
{
	import flash.utils.Dictionary;
	import org.web.sdk.handler.IDispatcher;
	
	public class EventedDispatcher implements IDispatcher 
	{
		private var compare:Dictionary;
		private var def_dispatcher:EventedDispatcher;
		private var allow_replace:Boolean;
		
		//一旦设置不允许替换 alow=false; 必须释放后才能重新设置
		public function EventedDispatcher(dispatch:EventedDispatcher = null, alow:Boolean = true) 
		{
			this.allow_replace = alow;
			if (null == dispatch) {
				def_dispatcher = this;
				compare = new Dictionary;
			}else {
				def_dispatcher = dispatch.getDispatcher();
			}
		}
		
		public function get allow():Boolean
		{
			return allow_replace;
		}
		
		//设置响应 可以替换
		public function setDispatcher(dispatch:EventedDispatcher):Boolean
		{
			if (!allow) return false;
			if (dispatch != def_dispatcher) destroy();
			def_dispatcher = dispatch.getDispatcher();
			return true;
		}
		
		/* INTERFACE org.web.sdk.system.inter.IZclient */
		public function listenfor(newName:String, called:Function):void
		{
			var vector:Vector.<Function> = getDispatcher().compare[newName] as Vector.<Function>;
			if (!isset(newName)) {
				vector = new Vector.<Function>;
				getDispatcher().compare[newName] = vector;
			}
			vector.push(called);
		}
		
		//并没有真正的删除 [不是自己不能删除]
		public function removeListener(newName:String,called:Function):void 
		{
			if (!isset(newName)) return;
			var vector:Vector.<Function> = getDispatcher().compare[newName] as Vector.<Function>;
			for (var i:int = 0; i < vector.length; i++)
			{
				if (called == vector[i]) {
					vector[i] = null;
					break;
				}
			}
			//if (vector.length == 0) delete getDispatcher().compare[newName];
		}
		
		public function isset(newName:String):Boolean
		{
			return getDispatcher().compare[newName] != undefined;
		}
		
		//不是自身不能删除
		public function removeLink(newName:String = null):void
		{
			if (!isset(newName)) return;
			if (newName == null) {
				var value:String;
				for (value in getDispatcher().compare) removeLink(value);
			}else {
				var vector:Vector.<Function> = getDispatcher().compare[newName] as Vector.<Function>;
				vector.splice(0, vector.length);
				delete getDispatcher().compare[newName];
			}
		}
		
		//发送的时候，如果命令设置为Null才删除 [无顺序可言]
		public function handler(newName:String, newRest:Object = null):void
		{
			if (!isset(newName)) return;
			var vector:Vector.<Function> = getDispatcher().compare[newName] as Vector.<Function>;
			var called:Function;
			const none:int = 0;
			var i:int = none;
			while (i < vector.length)
			{
				called = vector[i];
				if (called is Function) {
					called.apply(null, [newRest]);
				}else {
					vector.splice(i, 1);
					continue;
				}
				i++;
			}
			if (vector.length == none) delete getDispatcher().compare[newName];
		}
		
		//是否自身注册
		public function isself():Boolean
		{
			return this == getDispatcher();
		}
		
		//不允许别人摧毁,但是别人可以调用removeLink一样摧毁
		public function destroy():void 
		{
			if (isself()) def_dispatcher.removeLink();
		}
		
		//不对外公开
		protected function getDispatcher():EventedDispatcher
		{
			return def_dispatcher;
		}
		//ends
	}

}