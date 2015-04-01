package org.web.sdk.loader 
{
	import org.web.sdk.loader.interfaces.ILoadRequest;
	
	public class LoadRequest implements ILoadRequest 
	{
		private var _url:String;
		private var _prior:Boolean;
		private var _version:String;
		private var _context:*;
		
		public function LoadRequest(url:String, version:String = null, context:*= undefined) 
		{
			_url = url;
			_version = version;
			_context = context;
		}
		
		/* INTERFACE org.web.sdk.loader.interfaces.ILoadRequest */
		public function get url():String 
		{
			return _url;
		}
		
		public function get version():String 
		{
			return _version;
		}
		
		public function get context():* 
		{
			return _context;
		}
		
		
		//end
	}

}