package org.web.sdk.display.form.interfaces 
{
	import org.web.sdk.interfaces.IDisplay;
	import org.web.sdk.display.form.lib.*;
	import org.web.sdk.display.form.ActionMethod;
	import org.web.sdk.display.form.Texture; 
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public interface IRender extends IDisplay
	{
		function setLiberty(txName:String, tag:int = -1, data:ActionMethod = null):Boolean;
		function getBufferRender(res:ResRender, action:ActionMethod = null):void;
		function updateBuffer(action:ActionMethod = null):void;
		function setTexture(texture:Texture):void;
		function clone():IRender;
		function getRes():ResRender;
		function cleanRender():void;
		//end
	}
	
}