package org.web.sdk.gpu.core 
{
	import flash.display.BitmapData;
	import org.web.sdk.FrameWork;
	
	public class CreateTexture 
	{
		public static var FPS:int = 100;
		public static const SUFF_ACTION:String = ".png";	
		
		//取动作列表
		public static function getTextures(name:String, start:int = 1, len:int = int.MAX_VALUE, url:String = null):Vector.<BitmapData>
		{
			var vector:Vector.<BitmapData> = new Vector.<BitmapData>;
			var index:int = start;
			var bit:BitmapData;
			while (true) {
				bit = createBitmapdata(name + index + SUFF_ACTION, url);
				index++;
				if (index > len) break;
				if (bit) vector.push(bit);
				else break;
			}
			return vector;
		}
		
		public static function createBitmapdata(name:String, url:String = null):BitmapData
		{
			return FrameWork.getAsset(name, url) as BitmapData;
		}
		
		//根据角色和方向取
		public static function getActionVectors(action:String, point:int = 0, url:String = null):Vector.<BitmapData>
		{
			var name:String = action.replace("%s", point);
			return getTextures(name, 1, int.MAX_VALUE, url);
		}
		
		//直接建立
		public static function getFactory(type:String,className:Class):TextureConductor
		{
			var conductor:TextureConductor = TextureSystem.gets().getConductor(type);
			if (null == conductor) conductor = new className(type);
			return conductor;
		}
		
		//ends
	}

}