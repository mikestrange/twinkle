package org.web.sdk.display 
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.interfaces.IBaseScene;
	import org.web.sdk.display.interfaces.IDirector;
	import org.web.sdk.inters.IBaseSprite;
	import org.web.sdk.Crystal;
	
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
			
		}
		
		protected function cleanLayer():void
		{
			for (var key:String in _dicLayer)
			{
				this.removeChild(_dicLayer[key]);
				_dicLayer[key] = null;
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
		
		public function createLayer(...rest):void 
		{
			var layer:*= null;
			var layerName:String;
			for (var i:int = 0; i < rest.length; i++) {
				layer = rest[i];
				if (layer is String) {
					layerName = layer as String;
					addLayer(layerName, new BaseSprite);
				}else if (layer is BaseSprite) {
					layerName = IBaseSprite(layer).getName();
					this.addLayer(layerName, layer as IBaseSprite);
				}else {
					throw Error("不能识别:" + layer);
				}
			}
		}
		
		protected function addLayer(name:String, layer:IBaseSprite):void
		{
			if (_dicLayer[name] != null) return;
			layer.lockMouse();
			_dicLayer[name] = layer;
			this.addDisplay(layer);
		}
		
		public function getLayer(name:String):IBaseSprite 
		{
			return _dicLayer[name];
		}
		
		public function addToLayer(sprite:IBaseSprite, layerName:String = null):void 
		{
			var layer:IBaseSprite = _dicLayer[layerName];
			if (layer) layer.addDisplay(sprite);
		}
		
		//end
	}

}