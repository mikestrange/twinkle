package org.web.sdk.interfaces 
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
		
		function get filters():Array;
		function set filters(value:Array):void;
		
		function get height():Number;
		function set height(value:Number):void;
		
		function get mask():DisplayObject;
		function set mask(value:DisplayObject):void;
		
		function get mouseX():Number;
		function get mouseY():Number;
		
		function get name():String;
		function set name(value:String):void;
		
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
		
		function hitTestObject(obj:DisplayObject):Boolean;
		function hitTestPoint(x:Number, y:Number, shapeFlag:Boolean = false):Boolean;
		//可以不用
		//function getBounds(targetCoordinateSpace:DisplayObject):Rectangle;
		//坐标转换
		function toGlobal(mx:Number = 0, my:Number = 0):Point;
		function toLocal(mx:Number = 0, my:Number = 0):Point;
		//新增接口
		//是否被添加到父亲
		function isAdded():Boolean;
		//完全释放
		function finality(value:Boolean = true):void;
		//清理滤镜
		function clearFilters():void;
		//定义操作值
		function getTag():uint;
		function setTag(value:uint):void;
		//父类操作
		function getFather():IBaseSprite;
		function removeFromFather(value:Boolean = false):void;
		//控制
		function setDisplayIndex(floor:int = -1):void;
		function moveTo(mx:Number = 0, my:Number = 0):void;
		//添加
		function addUnder(father:IBaseSprite, floor:int = -1):Boolean;
		//校正位置
		//function setAlign(alignType:String, offx:Number = 0, offy:Number = 0):void
		//function get offsetx():Number;
		//function get offsety():Number;
		//设置尺寸
		function setSize(wide:int, high:int):void;
		function get sizeWidth():int;
		function get sizeHeight():int;
		//外部调用时候 [帧渲染]
		function frameRender(float:int = 0):void;
		//和原始大小相比,增加或者减少
		function setScale(sx:Number = 1, sy:Number = 1):void;
		//把自己转换
		function convertDisplay():DisplayObject;
		//帧事件
		function setRunning(value:Boolean = false):void;
		//舞台大小改变的时候调整
		function setResize(value:Boolean = true):void;
		//ends
	}
	
}