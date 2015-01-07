package org.web.sdk.system.events 
{
	/*消息*/
	public class Evented 
	{
		public static const CLIENT_SEND:int = 1;				//客服端推送
		public static const SERVER_CALL_CLIENT:int = 3;			//服务器发送
		public static const NONE_TYPE:int = -1;					//无类型表示,也是本地推送
		//
		private var _name:String;
		private var _data:Object;
		private var _client:*;		//的意义在于，我可以携带一个本体或者一个事件器或者一个回调函数过去，也可以叫承载器		
		private var _type:int;
		
		public function Evented($name:String, $data:Object = null, $client:*= undefined, $type:int = NONE_TYPE)
		{
			_name = $name;
			_data = $data;
			_client = $client;
			_type = $type;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
			
		public function get client():*
		{
			return _client;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function toString():String
		{
			return "[ Message -> name:" + _name+",type:" + type+"]";
		}
		//ends
	}
}