package org.web.sdk.interfaces 
{
	
	/**
	 * ...
	 * @author Main
	 */
	public interface IAlign 
	{
		//设置位置偏移
		function setAlignOffset(offx:Number = 0, offy:Number = 0, alignType:String = null):void;
		function get offsetx():Number;
		function get offsety():Number;
		function get alignType():String;
		//ends
	}
	
}