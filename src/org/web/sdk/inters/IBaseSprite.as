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
		function initialization(value:Boolean = true):void;
		function showEvent(event:Event = null):void;
		function hideEvent(event:Event = null):void;
		function lock(child:Boolean = true):void;
		function unlock(child:Boolean = true):void;
		function isEmpty():Boolean;
		function clearChildren():void;					//单纯的删除，不释放
		function finality(value:Boolean = true):void;	//释放所有
		function onResize(target:Object = null):void;	//调整位置
		function addDisplay(dis:IDisplayObject, mx:Number = 0, my:Number = 0, floor:int = -1):void;
		function removeByName(disName:String):DisplayObject;
		function get numChildren():int;
		function get graphics():Graphics;
		//ENDS
	}
	
}