package org.web.sdk.pool 
{
	import flash.display.BitmapData;
	import org.web.sdk.utils.HashMap;
	/**
	 * ...
	 * 具体实现，请扩展本类
	 */
	public class Photos 
	{
		private static var _ins:Photos;
		
		public static function create():Photos
		{
			if (null == _ins) _ins = new Photos;
			return _ins;
		}
		
		//
		private var _protoKeys:HashMap = new HashMap;
		
		//保存一张图 
		public function share(url:String, bit:BitmapData):Boolean
		{
			if (null == bit) return false;
			if (!has(url)) {
				_protoKeys.put(url, new ImageData(url, bit));
				return true;
			}
			return false;
		}
		
		//不用了的从这里删除下
		public function remove(url:String):Boolean
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
		public function deletes(url:String):void 
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
		public function gets(url:String):BitmapData
		{
			var image:ImageData = _protoKeys.getValue(url);
			if (null == image) return null;
			image.leng++;
			return image.bitmapdata;
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