package org.web.sdk.system.com 
{
	import org.web.sdk.system.events.Evented;
	
	public interface ICommand 
	{
		function execute(event:Evented):void;
	}
}