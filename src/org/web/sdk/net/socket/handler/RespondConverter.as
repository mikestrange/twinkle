package org.web.sdk.net.socket.handler 
{
	import org.web.sdk.handler.Observer;
	import org.web.sdk.net.events.RespondEvented;
	import org.web.sdk.net.socket.inter.ICmdHandler;
	import org.web.sdk.net.socket.inter.ISocketRespond;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.utils.UniqueHash;
	
	/*
	 * 处理命令的转换器，基类
	 * */
	public class RespondConverter implements ICmdHandler 
	{
		private var vector:Vector.<Observer>;
		private var warrior:Function;
		public var cmdHash:UniqueHash;
		
		public function RespondConverter() 
		{
			vector = new Vector.<Observer>;
			cmdHash = new UniqueHash;		//自身处理注册
			register();
		}
		
		public function register():void
		{
			
		}
		
		/* INTERFACE org.web.sdk.net.inters.ICmdHandler */
		public function replace(called:Function = null):void 
		{
			this.warrior = called;
		}
		
		public function handler(cmd:Number, target:Object = null):void 
		{
			var respond:ISocketRespond = null;
			if (this.warrior is Function) {
				respond = warrior(cmd, target as RespondEvented);
			}else {
				respond = execute(cmd, target as RespondEvented);
			}
			if (respond == null) return;
			var index:int = 0;
			var list:Vector.<Observer> = vector.slice(index, vector.length);
			for (; index < list.length; index++) list[index].dispatch([respond.getMessage()]);
			list = null;
		}
		
		//处理
		protected function execute(cmd:uint, event:RespondEvented):ISocketRespond
		{
			
			return null;
		} 
		
		public function add(notice:Function):void 
		{
			vector.push(new Observer(this, notice));
		}
		
		public function remove(notice:Function):Boolean 
		{
			for (var i:int = 0; i < vector.length; i++) {
				if (vector[i].handler == notice) {
					vector[i].destroy();
					vector.splice(i, 1);
					break;
				}
			}
			return vector.length == 0;
		}
		
		public function destroy():void
		{
			
		}
		
		public function empty():Boolean 
		{
			return vector.length == 0;
		}
		
		//ends
	}

}