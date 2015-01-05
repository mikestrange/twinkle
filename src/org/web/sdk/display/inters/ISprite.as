package org.web.sdk.display.inters 
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.geom.Point;
	
	public interface ISprite
	{
		//从父类移除
		function hide():void;
		//自身固定显示
		function show():void;
		//是否显示，也就是是否被父亲添加
		function isshow():Boolean;
		//初始化是否成功
		function initialization():void;
		//设置名称或者子项的层级
		function setDisplayLayer(any:*, index:int = -1):void;
		//移除名称的子项
		function removeChildByName(disName:String):DisplayObject;
		//添加一个物体，包含名称和层级，默认无名称和顶级
		function addChildDoName(dis:DisplayObject, disName:String = null, floor:int = -1):DisplayObject;
		//移动到
		function moveTo(mx:Number = 0, my:Number = 0):void;
		//跟随一个物体
		function follow(dis:DisplayObject, ofx:Number = 0, ofy:Number = 0, global:Boolean = false):void;
		//禁止所有子项
		function lock():void;
		//所有子项解锁
        function unlock():void;
		//设置尺寸
		function setNorms(horizontal:Number = 1, vertical:Number = 1, ratio:Boolean = true):void;
		//释放子集
		function finality(value:Boolean = true):void;
		//释放自身，包括父类移除和释放所有资源
		function dispose():void;
		//取名称子项
		function getChildByName(name:String):DisplayObject;
		//是否存在名称的子集
		function isByName(name:String):Boolean;
		//移动至
		function moveToPoint(value:Point):void;
		//清除绘制
		function clearDraw():void;
		//自身名称
		function getName():String;
		//绘制背景
		function drawBack(mx:Number = 0, my:Number = 0, across:Number = 0, vertical:Number = 0, color:uint = 0):void;
		//绘制
		function get graphics():Graphics;
		//渲染
		function render():void;
		//ends
	}
	
}