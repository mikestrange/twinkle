package org.web.sdk.display.core.house 
{
	import org.web.sdk.display.core.house.ILayer;
	
	internal class LayerData 
	{
		public var name:String;
		public var floor:int;
		public var mouse:Boolean;
		public var layer:ILayer;
		
		public function LayerData(name:String, floor:int = 0, mouse:Boolean = false)
		{
			this.name = name;
			this.floor = floor;
			this.mouse = mouse;
		}
		
		public function getLayer():ILayer
		{
			if (layer == null) layer = new Layer(name, mouse);
			return layer;
		}
		
		public function isLayer():Boolean
		{
			return layer != null;
		}
		
		public function destroy():void
		{
			if (layer) layer.hide();
			layer = null;
		}
		//ends
	}
}