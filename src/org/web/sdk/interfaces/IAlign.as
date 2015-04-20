package org.web.sdk.interfaces 
{
	
	/**
	 * ...
	 * @author Main
	 */
	public interface IAlign 
	{
		//设置位置偏移
		function setAlignOffset(alignType:String = null, offx:Number = 0, offy:Number = 0):void;
		function get offsetx():Number;
		function get offsety():Number;
		function get alignType():String;
		function set offsetRotation(value:Number):void;
		function get offsetRotation():Number;
		//ends
	}
	
}