package org.web.sdk.net.web 
{
	/**
	 * ...
	 * @author Main
	 */
	public class WebData 
	{
		public var cmd:int;
		public var url:String;
		public var client:*= undefined;
		
		public function WebData(cmd:int, url:String, client:*= undefined) 
		{
			this.cmd = cmd;
			this.url = url;
			this.client = client;
		}
		//ends
	}

}