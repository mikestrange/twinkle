package org.web.sdk.net.web 
{
	public class NetResult 
	{
		private var _result:Function;
		private var _status:Function;
		
		public function NetResult(result:Function, status:Function = null) 
		{
			_result = result;
			_status = status;
		}
		
		public function onResult(data:Object):void
		{
			_result(data);
		}
		
		public function onStatus(type:int = 0):void
		{
			if (_status is Function) _status(type);
		}
		//end
	}

}