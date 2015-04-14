package org.web.sdk.display.form.interfaces 
{
	import org.web.sdk.interfaces.IDisplay;
	import org.web.sdk.display.form.lib.*;
	import org.web.sdk.display.form.AttainMethod;
	import org.web.sdk.display.form.Texture; 
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public interface IRender extends IDisplay
	{
		function seekByName(txName:String, tag:int = -1, data:AttainMethod = null):Boolean;
		function getBufferRender(res:ResRender, action:AttainMethod = null):void;
		function updateBuffer(action:AttainMethod = null):void;
		function setTexture(texture:Texture):void;
		function clone():IRender;
		function getResource():ResRender;
		function cleanRender():void;
		function isRender():Boolean;
		//end
	}
	
}