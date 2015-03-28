package org.web.sdk.system.inter 
{
	import org.web.sdk.system.events.Evented;

	public interface IController 
	{
		function getName():String;
		function getSecretlyNotices():Array;
		function launch(notice:IMessage):void;
		function dutyEvented(event:Evented):void;
		function free():void;
		//
	}
	
}