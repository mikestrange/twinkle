package org.web.sdk.load 
{
	import org.web.sdk.global.DateTimer;
	import org.web.sdk.load.interfaces.ILoadRequest;
	
	public class LoadRequest implements ILoadRequest 
	{
		private var _url:String;
		private var _version:String;
		private var _context:*;
		
		public function LoadRequest(url:String, version:String = null, context:*= undefined) 
		{
			_url = url;
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
			return _url;
		}
		
		//loader url
		public function get loadUrl():String
		{
			if (_version) {
				var index:int = _url.indexOf("?");
				if (index == -1) return _url + "?" + getVersion(_version);
				return _url + "&" + getVersion(_version);
			}
			return _url;
		}
		
		//
		private static const VERSION:String = "ver=%s";
		
		private static function getVersion(value:String):String
		{
			return VERSION.replace("%s", value);
		}
		
		//end
	}

}