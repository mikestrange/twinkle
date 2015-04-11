package org.web.sdk.display.core.com.interfaces 
{
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 触发器
	 */
	public interface ITouch extends IElement 
	{
		function setSelect():void;
		function setCancel():void;
		function isSelected():Boolean;	
		//选择器
	}
}