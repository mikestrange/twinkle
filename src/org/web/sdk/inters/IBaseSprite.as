package org.web.sdk.inters 
{
	public interface IBaseSprite extends IDisplay
	{
		function isEmpty():Boolean;
		function clearChildren():void;
		function lockMouse(childs:Boolean = true):void;
		function unlockMouse(childs:Boolean = true):void;
		function removeByName(childName:String):IDisplay;
		function getChildrenByOper(value:int = 0):Vector.<IDisplay>;
		function addDisplay(child:IDisplay, floor:int = -1):Boolean;
		//end
	}
	
}