package org.web.sdk.handler 
{
	import flash.utils.Dictionary;
	import org.web.sdk.frame.observer.Observer;
	import org.web.sdk.handler.IDispatcher;
	/*
	 * 一个比较好的事件拍发起
	 * */
	public class EventedDispatcher implements IDispatcher 
	{
		private var compare:Dictionary;
		private var def_dispatcher:EventedDispatcher;
		
		//一旦设置不允许替换 alow=false; 必须释放后才能重新设置
		public function EventedDispatcher(dispatch:EventedDispatcher = null) 
		{
			if (null == dispatch) {
				def_dispatcher = this;
				compare = new Dictionary;
			}else {
				def_dispatcher = dispatch.dispatcher;
			}
		}
		
		/* INTERFACE org.web.sdk.system.inter.IZclient */
		public function addNotice(notice:String, called:Function):void
		{
			var vector:Vector.<Observer> = dispatcher.compare[notice] as Vector.<Observer>;
			if (!isset(notice)) {
				vector = new Vector.<Observer>;
				dispatcher.compare[notice] = vector;
			}
			vector.push(new Observer(this, called));
		}
		
		public function removeNotice(notice:String, called:Function):void
		{
			if (!isset(notice)) return;
			var vector:Vector.<Observer> = dispatcher.compare[notice] as Vector.<Observer>;
			for (var i:int = vector.length - 1; i >= 0; i--)
			{
				//vector[i].match(this) &&  不需要
				if (called == vector[i].handler) {
					vector[i].destroy();
					vector.splice(i, 1);
					break;
				}
			}
			if (vector.length == 0) {
				dispatcher.compare[notice] = null;
				delete dispatcher.compare[notice];
			}
		}
		
		public function isset(notice:String):Boolean
		{
			return dispatcher.compare[notice] != undefined;
		}
		
		//不是自身不能删除
		public function removeLink(notice:String = null):void
		{
			if (!isset(notice)) return;
			if (notice == null) {
				var value:String;
				for (value in dispatcher.compare) removeLink(value);
			}else {
				var vector:Vector.<Observer> = dispatcher.compare[notice] as Vector.<Observer>;
				dispatcher.compare[notice] = null;
				delete dispatcher.compare[notice];
				const begin:int = 0;
				while (vector.length) {
					vector[begin].destroy();
					vector.shift();
				}
			}
		}
		
		//发送的时候，如果命令设置为Null才删除 [无顺序可言]
		public function dispatchNotice(notice:String, ...events):void
		{
			if (!isset(notice)) return;
			var vector:Vector.<Observer> = dispatcher.compare[notice] as Vector.<Observer>;
			var index:int = 0;
			var list:Vector.<Observer> = vector.slice(index, vector.length);
			for (; index < list.length; index++) list[index].dispatch(events);
			list = null;
		}
		
		//是否自身注册
		public function isself():Boolean
		{
			return this == dispatcher;
		}
		
		//不允许别人摧毁,但是别人可以调用removeLink一样摧毁
		public function destroy():void 
		{
			if (isself()) def_dispatcher.removeLink();
		}
		
		//不对外公开
		protected function get dispatcher():EventedDispatcher
		{
			return def_dispatcher;
		}
		//ends
	}

}