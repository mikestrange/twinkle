package org.web.sdk.inters 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public interface IBaseSprite extends IDisplayObject
	{
		function lock():void;
		function unlock():void;
		function get numChildren():int;
		function get graphics():Graphics;
		function isEmpty():Boolean;
		//
		function removeChildByName(disName:String):DisplayObject;
		function isByName(disName:String):Boolean;
		function clearChildren():void;
		function addChildByName(child:IDisplayObject, sonName:String, index:int = -1):IDisplayObject;
		//
		function initialization(value:Boolean = true):void;
		function show():void;
		function hide():void;
		function showEvent(event:Event = null):void;
		function hideEvent(event:Event = null):void;
		function finality(value:Boolean = true):void;
		function onResize(target:Object = null):void;
		//ENDS
	}
	
}