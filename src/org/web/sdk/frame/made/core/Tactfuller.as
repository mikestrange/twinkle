package org.web.sdk.frame.made.core 
{
	import org.web.sdk.frame.made.interfaces.IApplicationListener;
	import org.web.sdk.frame.made.interfaces.IRoutine;
	
	/**
	 * 只能作为嫁接
	 */
	public class Tactfuller implements IRoutine 
	{
		private var _cumulative:Boolean = true;
		private var _appListener:IApplicationListener;
		private var _links:Vector.<String>
		
		/* INTERFACE org.web.sdk.frame.interfaces.ITactful */
		public function isCumulative():Boolean 
		{
			return _cumulative;
		}
		
		public function setCumulative(value:Boolean):void 
		{
			_cumulative = value;
		}
		
		public function setLinks(applistner:IApplicationListener, vector:Vector.<String>):void 
		{
			_appListener = applistner;
			_links = vector;
		}
		
		public function getLinks():Vector.<String> 
		{
			return _links;
		}
		
		public function tickEvent(name:String, parameter:Object = null):void 
		{
			
		}
		
		public function getApplicationListener():IApplicationListener 
		{
			return _appListener;
		}
		
		//ends
	}

}