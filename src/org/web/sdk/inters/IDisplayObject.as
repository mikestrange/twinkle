package org.web.sdk.inters 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	
	public interface IDisplayObject extends IEventDispatcher 
	{
		function get alpha():Number;
		function set alpha(value:Number):void;
		
		function get cacheAsBitmap():Boolean;
		function set cacheAsBitmap(value:Boolean):void;
		
		function clearFilters():void;
		function get filters():Array;
		function set filters(value:Array):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function get mask():DisplayObject;
		function set mask(value:DisplayObject):void;
		
		function get mouseX():Number;
		function get mouseY():Number;
		function getMouse():Point;
		
		function get name():String;
		function set name(value:String):void;
		
		//function get parent():DisplayObjectContainer;
		function getParent():IBaseSprite;
		
		function get root():DisplayObject;
		
		function get rotation():Number;
		function set rotation(value:Number):void;
		
		function get scale9Grid():Rectangle;
		function set scale9Grid(innerRectangle:Rectangle):void;
		
		function get scaleX():Number;
		function set scaleX(value:Number):void;
		
		function get scaleY():Number;
		function set scaleY(value:Number):void;
		
		function get stage():Stage;
		
		function get transform():Transform;
		function set transform(value:Transform):void;
		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		function get width():Number;
		function set width(value:Number):void;
		
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;
		
		function globalToLocal(point:Point):Point;
		function localToGlobal(point:Point):Point;
		
		function hitTestObject(obj:DisplayObject):Boolean;
		function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean;
		//新增接口
		function addInto(father:IBaseSprite, mx:Number = 0, my:Number = 0, floor:int = -1):void;
		function moveTo(mx:int = 0, my:int = 0):void;
		function setNorms(horizontal:Number = 1, vertical:Number = 1, ratio:Boolean = true):void;
		function follow(dis:IDisplayObject, ofx:Number = 0, ofy:Number = 0, global:Boolean = false):void;
		//
		function render():void;
		function isshow():Boolean;
		function removeFromFather():void;
		function setAuto(type:String = null):void;
		function showEvent(event:Event = null):void;
		function hideEvent(event:Event = null):void;
		//ends
	}
	
}