package org.web.sdk.display.core.com.interfaces 
{
	import org.web.sdk.interfaces.IBaseSprite;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public interface IListItem extends IBaseSprite
	{
		function setFloor(value:int):void;
		function get floor():int;
		function setOpen(value:Boolean):void;
		function isOpen():Boolean;
		//ends
	}
	
}