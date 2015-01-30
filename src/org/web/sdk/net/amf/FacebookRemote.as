package org.web.sdk.net.amf 
{
	public class FacebookRemote extends AMFRemoting 
	{
		
		public function FacebookRemote() 
		{
			this.connectRemote();
		}
		
		override protected function onResult(response:Object):void 
		{
			super.onResult(response);
			
		}
		
		override protected function onFault(response:Object = null):void 
		{
			super.onFault(response);
			
		}
		//ends
	}

}