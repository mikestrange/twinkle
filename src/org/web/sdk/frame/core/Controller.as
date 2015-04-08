package org.web.sdk.frame.core 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.web.sdk.frame.interfaces.IController;
	
	public class Controller implements IController 
	{
		private var _name:String;
		
		public function Controller(name:String = null) 
		{
			_name = name;
		}
		
		/* INTERFACE org.web.sdk.frame.interfaces.ILogic */
		public function getName():String 
		{
			if (_name) return _name;
			return getQualifiedClassName(this).replace("::", ".");
		}
		
		public function launch():void 
		{
			
		}
		
		public function free():void 
		{
			
		}
		//end
	}

}