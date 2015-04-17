package org.web.sdk.interfaces 
{
	import flash.display.Sprite;
	
	public interface IBaseSprite extends IDisplayObject
	{
		function isEmpty():Boolean;
		function clearChildren():void;
		function lockMouse(childs:Boolean = true):void;
		function unlockMouse(childs:Boolean = true):void;
		function removeByName(childName:String):IDisplayObject;
		function getChildren(tag:int = -1):Array;
		function addDisplay(child:IDisplayObject, floor:int = -1):Boolean;
		function convertSprite():Sprite;
		function getName():String;
		//end
	}
	
}