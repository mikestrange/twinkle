package org.web.sdk.load.core 
{
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	
	public class BelieveLoader
	{
		private static var _loader:PerfectLoader = PerfectLoader.gets();
		
		protected function complete(e:LoadEvent):void
		{
			
		}
		
		public function get loader():PerfectLoader
		{
			return _loader;
		}
		//ends
	}

}
