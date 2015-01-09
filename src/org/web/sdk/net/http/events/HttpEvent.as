package org.web.sdk.net.http.events 
{
	import flash.events.Event;
	
	public class HttpEvent extends Event 
	{
		public static const ERROR:String = 'http_error';
		public static const COMPLETE:String = 'http_complete';
		
		public function HttpEvent(type:String) 
		{
			super(type, false, false);
		}
		
		//ends
	}

}