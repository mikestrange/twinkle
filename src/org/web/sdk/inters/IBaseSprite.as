package org.web.sdk.inters 
{
	public interface IBaseSprite extends IDisplayObject
	{
		function isEmpty():Boolean;
		function clearChildren():void;
		function lockMouse(childs:Boolean = true):void;
		function unlockMouse(childs:Boolean = true):void;
		function removeByName(childName:String):IDisplayObject;
		function getChildrenByOper(value:int = 0):Vector.<IDisplayObject>;
		function addDisplay(child:IDisplayObject, floor:int = -1):Boolean;
		//
		function setAlign(alignType:String, offx:Number = 0, offy:Number = 0):void
		function get offsetx():Number;
		function get offsety():Number;
		//end
	}
	
}