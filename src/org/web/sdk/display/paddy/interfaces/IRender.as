package org.web.sdk.display.paddy.interfaces 
{
	import org.web.sdk.interfaces.IDisplay;
	import org.web.sdk.display.paddy.Texture; 
	import org.web.sdk.display.paddy.covert.SmartRender;
	import org.web.sdk.display.paddy.covert.FormatMethod;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public interface IRender extends IDisplay
	{
		//我们不公开外部自定义
		function setBufferRender(res:SmartRender, data:FormatMethod = null):void;
		function setCompulsory(format:String, namespaces:String = null, type:int = 0):void;
		function setResource(resName:String):Boolean;
		function retakeTarget(data:Object):void;
		function getResource():SmartRender;
		function isRender():Boolean;
		function clone():IRender;
		//end
	}
	
}