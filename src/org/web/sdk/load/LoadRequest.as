package org.web.sdk.load 
{
	import org.web.sdk.load.interfaces.ILoadRequest;
	
	public class LoadRequest implements ILoadRequest 
	{
		private var _loadUrl:String;
		private var _version:String;
		private var _context:*;
		
		public function LoadRequest(url:String, version:String = null, context:*= undefined) 
		{
			_loadUrl = url;
			_version = version;
			_context = context;
		}
		
		/* INTERFACE org.web.sdk.loader.interfaces.ILoadRequest */
		public function get version():String 
		{
			return _version;
		}
		
		public function get context():* 
		{
			return _context;
		}
		
		public function get type():String
		{
			return null;
		}
		
		public function get url():String
		{
			return _loadUrl;
		}
		
		public function set url(value:String):void
		{
			_loadUrl = value;	
		}
		//end
	}

}