package org.web.sdk.display.form.interfaces 
{
	import org.web.sdk.interfaces.IDisplay;
	import org.web.sdk.display.form.lib.*;
	import org.web.sdk.display.form.lib.AttainMethod;
	import org.web.sdk.display.form.Texture; 
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public interface IRender extends IDisplay
	{
		//我们不公开外部自定义
		function setBufferRender(res:ResRender, data:AttainMethod = null):void;
		function setCompulsory(format:String, namespaces:String = null, type:int = 0):void;
		function setResource(resName:String):Boolean;
		function retakeTarget(data:Object):void;
		function getResource():ResRender;
		function isRender():Boolean;
		function clone():IRender;
		//end
	}
	
}