package org.web.sdk.display 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import org.web.sdk.display.ILayer;
	import org.web.sdk.log.Log;
	import org.web.sdk.system.GlobalMessage;
	import org.web.sdk.utils.HashMap;
	
	final public class House
	{
		private static var house:House;	
		
		public static function get nativer():House
		{
			if (house == null) house = new House;
			return house;
		}
		
		private var _root:DisplayObjectContainer = null;
		private var _layerHash:HashMap = new HashMap;
		
		public function set root(value:DisplayObjectContainer):void
		{
			_root = value;
		}
		
		public function get root():DisplayObjectContainer
		{
			return _root;
		}
		
		//当前多少个窗口
		public function length():Number
		{
			return root.numChildren;
		}
		
		//基础的建立,并没有生成
		public function createLayer(name:String, floor:int = 0, mouse:Boolean = false):Boolean
		{
			if (_layerHash.isKey(name)) return false;
			_layerHash.put(name, new LayerData(name, floor, mouse));
			return true;
		}
		
		//彻底删除
		public function deleteLayer(name:String):void
		{
			var data:LayerData = _layerHash.remove(name);
			if (data) data.destroy();
		}
		
		//清理所有图层
		public function clear():void 
		{
			_layerHash.eachKey(deleteLayer);
			_layerHash = new HashMap;
		}
		
		//永久的设置
		public function sweptIndex(name:String, floor:int = 0):void
		{
			var data:LayerData = _layerHash.getValue(name);
			if (data) {
				data.floor = floor;
				if (!data.isLayer()) return;
				addLayer(data);
			}
		}
		
		//为窗口添加图层 Layer
		public function addToLayer(dis:DisplayObject, name:String):Boolean
		{
			var data:LayerData = _layerHash.getValue(name);
			if (data) {
				if (!data.isLayer()) addLayer(data);			//图层添加到舞台
				data.layer.addToLayer(dis);	
				return true;
			}
			return false
		}
		
		public function removeToLayer(dis:DisplayObject, name:String):void 
		{
			var data:LayerData = _layerHash.getValue(name);
			if (data) {
				if (!data.isLayer()) return;
				data.layer.removeToLayer(dis);
				if (data.layer.isEmpty()) data.destroy();
			}
		}
		
		private function addLayer(value:LayerData):void
		{
			var layer:Layer = value.getLayer() as Layer;
			if (_root.numChildren == 0) {
				_root.addChild(layer);
			}else {
				var data:LayerData;
				var index:int = _root.numChildren - 1;
				for (; index >= 0; index--)
				{
					data = _layerHash.getValue(_root.getChildAt(index).name);
					if (data == null) continue;
					if (value.floor >= data.floor) {
						index = index + 1;
						break;
					}
				}
				if (index < 0) index = 0;
				_root.addChildAt(layer, index);
			}
		}
		//ends
	}
}