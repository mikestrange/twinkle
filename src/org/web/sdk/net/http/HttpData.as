package org.web.sdk.net.http 
{
	public class HttpData 
	{
		public var module:String;
		public var order:String;
		public var code:uint;
		public var data:*;
		public var client:*;
	
		public function HttpData(module:String, order:String, data:Object, client:*, code:uint)
		{
			this.module = module;
			this.order = order;
			this.data = data;
			this.code = code;
			this.client = client;
		}
		
		public function toString():String 
		{
			return "[module=" + module + ",order=" + order + ",code=" + code + ",data=" + data + "]";
		}
		
		//ends
	}
}