package org.web.sdk.display.interfaces 
{
	import org.web.sdk.inters.IBaseSprite;
	
	public interface IBaseScene extends IBaseSprite 
	{
		function onEnter():void;
		function onExit():void;
		//
		function get prevScene():IBaseScene;
		function get nextScene():IBaseScene;
		function set prevScene(value:IBaseScene):void;
		function set nextScene(value:IBaseScene):void;
		//调整
		function updateResize():void;
		//建立图层
		function createLayer(name:String, floor:int = -1):IBaseSprite;
		function getLayer(name:String):IBaseSprite;
		function addToLayer(sprite:IBaseSprite, layerName:String = null):void;
		//end
	}
	
}