package org.web.sdk.gpu
{
	import flash.display.BitmapData;
	import org.web.sdk.inters.IBuffer;
	import org.web.sdk.load.core.BelieveLoader;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.utils.HashMap;
	/**
	 * ...
	 *动态下载静态贴图
	 */
	public class Assets extends BelieveLoader 
	{
		private static var _ins:Assets;
		
		public static function gets():Assets
		{
			if (null == _ins) _ins = new Assets;
			return _ins;
		}
		
		private var _protoKeys:HashMap = new HashMap;
		
		public function load(asset:IBuffer):IBuffer
		{
			if (has(asset.resource)) {
				mark(asset);
			}else {
				loader.addWait(asset.resource, LoadEvent.IMG).addRespond(asset.complete);
				loader.start();
			}
			return asset;
		}
		
		//不用了的从这里删除下
		public function unmark(url:String):Boolean
		{
			var image:ImageData = _protoKeys.getValue(url);
			if (null == image) return false;
			if (--image.leng <= 0) {
				_protoKeys.remove(url);
				image.dispose();
			}
			return true;
		}
		
		//释放一个纹理
		public function remove(url:String):void 
		{
			var image:ImageData = _protoKeys.remove(url);
			if (image) image.dispose();
		}
		
		//是否存在这张照片
		public function has(url:String):Boolean
		{
			return _protoKeys.isKey(url);
		}
		
		//取一张图 只有在取的时候才记录备份出去了多少
		public function mark(asset:IBuffer, bit:BitmapData = null):Boolean
		{
			if (asset.resource == null) return false;
			var image:ImageData = _protoKeys.getValue(asset.resource);
			if (image == null) {
				if (bit == null) return false;
				image = new ImageData(asset.resource, bit);
				_protoKeys.put(asset.resource, image);
			}
			image.leng++;
			asset.setTexture(image.texture);
			return true;
		}
		
		//释放整个模块
		public function free():void
		{
			_protoKeys.eachValue(dispose);
			_protoKeys.clear();
		}
		
		public function toString():String 
		{
			var arr:Array = _protoKeys.getValues();
			var chat:String = '[图片资源库:\n';
			var bit:ImageData;
			for (var i:int = 0; i < arr.length; i++)
			{
				bit = arr[i];
				chat += "url=" + bit.url + ",len=" + bit.leng + "\n";
			}
			chat += "->总共:" + arr.length + "]";
			return chat;
		}
		
		private function dispose(image:ImageData):void 
		{
			image.dispose();
		}
		//ends
	}
}


import flash.display.BitmapData;
import org.web.sdk.gpu.texture.VRayTexture;

class ImageData {
	
	public var leng:int;
	public var url:String;
	public var texture:VRayTexture;
	
	public function ImageData(path:String, bit:BitmapData, leng:int = 0)
	{
		this.url = path;
		this.texture = VRayTexture.fromBitmapdata(bit);
		this.leng = leng;
	}
	
	public function dispose():void
	{
		if (texture) {
			texture.dispose();
			texture = null;
		}
	}
	//ends
}