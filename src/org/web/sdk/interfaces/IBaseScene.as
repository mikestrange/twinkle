package org.web.sdk.interfaces 
{
	import flash.display.Sprite;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.display.Director;
	
	public interface IBaseScene extends IBaseSprite
	{
		function onEnter():void;
		function onExit():void;
		//
		function get prevScene():IBaseScene;
		function get nextScene():IBaseScene;
		function set prevScene(prev:IBaseScene):void;
		function set nextScene(next:IBaseScene):void;
		//调整
		function updateResize():void;
		//快速建立
		function createLayer(...rest):void;
		function getLayer(name:String):IBaseSprite;
		function addToLayer(sprite:IBaseSprite, layerName:String = null):void;
		//end
	}
	
}