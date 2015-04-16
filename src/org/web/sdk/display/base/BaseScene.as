package org.web.sdk.display.base 
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.interfaces.IBaseScene;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.interfaces.IDisplay;
	
	public class BaseScene extends BaseSprite implements IBaseScene 
	{
		private var _nextScene:IBaseScene;
		private var _prevScene:IBaseScene;
		private var _dicLayer:Dictionary;
		
		public function BaseScene()
		{
			_dicLayer = new Dictionary;
		}
		
		/* INTERFACE org.web.sdk.display.interfaces.IBaseScene */
		public function onEnter():void 
		{
			
		}
		
		public function onExit():void 
		{
			_dicLayer = new Dictionary;
			this.removeFromFather(true);
		}
		
		protected function cleanLayer():void
		{
			for each(var layer:IBaseSprite in _dicLayer)
			{
				layer.removeFromFather(true);
			}
			_dicLayer = new Dictionary;	
		}
		
		public function get prevScene():IBaseScene 
		{
			return _prevScene;
		}
		
		public function get nextScene():IBaseScene 
		{
			return _nextScene;
		}
		
		public function set prevScene(value:IBaseScene):void 
		{
			_prevScene = value;
		}
		
		public function set nextScene(value:IBaseScene):void 
		{
			_nextScene = value;
		}
		
		public function updateResize():void 
		{
			
		}
		
		public function createLayer(layerName:String):void
		{
			var layer:IBaseSprite = getLayer(layerName);
			if (layer) layer.removeFromFather(true);
			layer = new BaseSprite;
			layer.lockMouse();
			_dicLayer[layerName] = layer;
		}
		
		public function addToLayer(display:IDisplay, layerName:String = null, floor:int = -1):void 
		{
			var layer:IBaseSprite = getLayer(layerName);
			if (layer) {
				layer.addDisplay(display, floor);
			}
		}
		
		public function getBaseSprite():IBaseSprite
		{
			return this;
		}
		
		//---自身才能操作图层
		protected function getLayer(layerName:String):IBaseSprite 
		{
			return _dicLayer[layerName];
		}
		//end
	}

}