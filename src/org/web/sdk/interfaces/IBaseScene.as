package org.web.sdk.interfaces 
{
	import flash.display.Sprite;
	import org.web.sdk.interfaces.IBaseSprite;
	
	public interface IBaseScene
	{
		function onEnter():void;
		function onExit():void;
		//prev
		function get prevScene():IBaseScene;
		function set prevScene(prev:IBaseScene):void;
		//next
		function get nextScene():IBaseScene;
		function set nextScene(next:IBaseScene):void;
		//调整
		function updateResize():void;
		//快速建立
		function createLayer(layerName:String):void;
		function addToLayer(display:IDisplayObject, layerName:String = null, floor:int = -1):void;
		//
		function getBaseSprite():IBaseSprite;
		//end
	}
}