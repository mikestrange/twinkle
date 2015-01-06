package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import org.web.sdk.inters.IAsset;
	import org.web.sdk.utils.HashMap;
	/**
	 * ...
	 *动态下载静态贴图
	 */
	public class Assets 
	{
		private static var _ins:Assets;
		
		public static function gets():Assets
		{
			if (null == _ins) _ins = new Assets;
			return _ins;
		}
		
		private var _protoKeys:HashMap = new HashMap;
		
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
		public function mark(asset:IAsset, bit:BitmapData = null):Boolean
		{
			if (asset.resource == null) return false;
			var image:ImageData = _protoKeys.getValue(asset.resource);
			if (image == null) {
				if (bit == null) return false;
				image = new ImageData(url, bit);
				_protoKeys.put(url, image);
			}
			image.leng++;
			asset.derive(image.bitmapdata);
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

class ImageData {
	
	public var leng:int = 0;
	public var bitmapdata:BitmapData;
	public var url:String;
	
	public function ImageData(path:String, bit:BitmapData, leng:int = 0)
	{
		this.url = path;
		this.bitmapdata = bit;
		this.leng = leng;
	}
	
	public function dispose():void
	{
		if (bitmapdata) {
			bitmapdata.dispose();
			bitmapdata = null;
		}
	}
	//ends
}