package org.web.sdk.context 
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	/**
	 *单独的资源域
	 */
	public class ResourceContext extends LoaderContext 
	{
		public function ResourceContext(checkPolicyFile:Boolean = false) 
		{
			super(checkPolicyFile, new ApplicationDomain, null);
		}
		
		public function hasDefinition(name:String):Boolean
		{
			return applicationDomain.hasDefinition(name);
		}
		
		public function getDefinition(name:String):Object
		{
			return applicationDomain.getDefinition(name);
		}
		
		public function getClass(name:String):Class
		{
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