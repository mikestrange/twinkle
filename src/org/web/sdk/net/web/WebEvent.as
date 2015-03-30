package org.web.sdk.net.web 
{
	public class WebEvent
	{
		public var cmd:int;
		public var url:String;
		//
		private var _result:NetResult;
		
		public function WebEvent(cmd:int, url:String, result:NetResult = null) 
		{
			this.cmd = cmd;
			this.url = url;
			this._result = result;
		}
		
		public function onResult(data:Object):void
		{
			if(_result) _result.onResult(data);
		}
		
		public function onStatus(type:int = 0):void
		{
			if (_result) _result.onStatus(type);
		}
		//ends
	}

}