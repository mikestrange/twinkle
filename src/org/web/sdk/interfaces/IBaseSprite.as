package org.web.sdk.interfaces 
{
	import flash.display.Sprite;
	
	public interface IBaseSprite extends IDisplay
	{
		function isEmpty():Boolean;
		function clearChildren():void;
		function lockMouse(childs:Boolean = true):void;
		function unlockMouse(childs:Boolean = true):void;
		function removeByName(childName:String):IDisplay;
		function getChildren(tag:int = -1):Array;
		function addDisplay(child:IDisplay, floor:int = -1):Boolean;
		function convertSprite():Sprite;
		function getName():String;
		//end
	}
	
}