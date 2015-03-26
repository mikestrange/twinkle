package org.web.sdk.fot.core 
{
	import org.web.sdk.fot.interfaces.IApplicationListener;
	import org.web.sdk.fot.interfaces.ITactful;
	
	/**
	 * 只能作为嫁接
	 */
	public class Tactfuller implements ITactful 
	{
		private var _cumulative:Boolean = true;
		private var _appListener:IApplicationListener;
		private var _links:Vector.<String>
		
		/* INTERFACE org.web.sdk.frame.interfaces.IVent */
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