package org.web.sdk.context 
{
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	/**
	 *单独的资源域
	 */
	public class ResourceContext
	{
		private var applicationDomain:ApplicationDomain;
			
		public function ResourceContext(checkFile:*) 
		{
			if (checkFile is Loader) applicationDomain = Loader(checkFile).contentLoaderInfo.applicationDomain;
			if (checkFile is ApplicationDomain) applicationDomain = checkFile;
		}
		
		public function hasDefinition(name:String):Boolean
		{
			return applicationDomain.hasDefinition(name);
		}
		
		public function getClass(name:String):Class
		{
			trace(applicationDomain,name)
				if (applicationDomain.hasDefinition(name)) {
				return applicationDomain.getDefinition(name) as Class;
			}
			return null;
		}
		
		public function getObject(name:String):Object
		{
			var classDefine:Class = getClass(name);
			if (classDefine) return new classDefine;
			return null;
		}
		//ends
	}
}