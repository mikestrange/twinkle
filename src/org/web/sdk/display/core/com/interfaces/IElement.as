package org.web.sdk.display.core.com.interfaces 
{
	import org.web.sdk.interfaces.IBaseSprite;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public interface IElement extends IBaseSprite
	{
		function get floor():int;
		function setFloor(value:int):void;
		function setOpen(value:Boolean):void;
		function isOpen():Boolean;
		//ends
	}
	
}