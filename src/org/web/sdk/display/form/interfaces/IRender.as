package org.web.sdk.display.form.interfaces 
{
	import org.web.sdk.interfaces.IDisplay;
	import org.web.sdk.display.form.lib.*;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public interface IRender
	{
		function setLiberty(txName:String, tag:int = -1, data:Object = null):Boolean;
		function setRender(res:ResRender, data:Object = null):void;
		function flush(data:Object = null):void;
		function clone():IRender;
		function getRes():ResRender;
		//end
	}
	
}