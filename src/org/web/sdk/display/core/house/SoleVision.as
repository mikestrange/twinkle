package org.web.sdk.display.core.house 
{
	import flash.display.DisplayObject;
	import org.web.sdk.display.core.BoneSprite;
	import org.web.sdk.display.inters.ILayer;
	import org.web.sdk.display.inters.IVision;
	
	//单你在某个图层下面添加的时候也能成立
	internal class SoleVision extends BoneSprite implements IVision 
	{
		public static const DEF_VISION:String = 'defVision';
		//
		private var _house:House;
		private var _key:String = '自身是不能建立窗口的!';
		
		//每个窗口用于对图层的控制
		public function SoleVision(house:House, vname:String = null, key:String = null)
		{
			this._house = house;
			this.mouseEnabled = false;
			this.name = vname == null ? DEF_VISION : vname;
			this.addEventListener('addedToStage', showEvent, false, 0, true);
			this.addEventListener('removedFromStage', hideEvent, false, 0, true);
		}
		
		//添加到舞台就意味添加到了房子里面
		override protected function showEvent(e:Object = null):void 
		{
			_house.addVision(this);
		}
		
		//移除房子
		override protected function hideEvent(e:Object = null):void 
		{
			_house.removeVision(this);
		}
		
		//房子可以操作所有的窗口
		public function get house():House
		{
			return _house;
		}
		
		public function closed():void
		{
			hide();
		}
		
		//创建一个图层
		public function addLayer(layer:ILayer, floor:int = -1):Boolean
		{
			if (isByName(layer.getName())) return false;
			trace("#[" + this + "]添加图层->", layer.getName());
			this.addChildDoName(layer as DisplayObject, layer.getName(), floor);
			return true;
		}
		
		//是否图层
		public function hasLayer(layerName:String):Boolean
		{
			return isByName(layerName);
		}
		
		//移除图层
		public function removeLayer(layerName:String):ILayer 
		{
			trace("#[" + this + "]移除图层->", layerName);
			return removeChildByName(layerName) as ILayer;
		}
		
		//取图层
		public function getLayer(layerName:String):ILayer
		{
			return getChildByName(layerName) as ILayer;
		}
		
		//置顶图层 ,不置顶就置低
		public function setLayerIndex(layerName:String, top:Boolean = true):void
		{
			if (top) setDisplayLayer(layerName, this.numChildren - 1);
			else setDisplayLayer(layerName, 0); 
		}
		
		public function length():Number
		{
			return this.numChildren;
		}
		
		//释放   [一般不允许调用]
		public function destroy():void 
		{
			super.dispose();
		}
		//
	}
}