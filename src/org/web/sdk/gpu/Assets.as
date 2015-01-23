package org.web.sdk.gpu
{
	import flash.display.BitmapData;
	import org.web.sdk.gpu.texture.BaseTexture;
	import org.web.sdk.inters.IAcceptor;
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
		
		public function load(asset:IAcceptor, complete:Function):IAcceptor
		{
			var resource:String = asset.resource;
			if (resource == null) return asset;
			if (has(resource)) {
				mark(asset, resource);
			}else {
				loader.addWait(resource, LoadEvent.IMG).addRespond(complete);
				loader.start();
			}
			return asset;
		}
		
		//不用了的从这里删除下
		public function unmark(resource:String):Boolean
		{
			var image:ImageData = _protoKeys.getValue(resource);
			if (null == image) return false;
			if (--image.length <= 0) {
				_protoKeys.remove(resource);
				image.dispose();
			}
			return true;
		}
		
		//释放一个纹理
		public function remove(resource:String):void 
		{
			var image:ImageData = _protoKeys.remove(resource);
			if (image) image.dispose();
		}
		
		//是否存在这张照片
		public function has(resource:String):Boolean
		{
			return _protoKeys.isKey(resource);
		}
		
		//取一张图 只有在取的时候才记录备份出去了多少
		public function mark(asset:IAcceptor, name:String, texture:BaseTexture = null):Boolean
		{
			var image:ImageData = _protoKeys.getValue(name);
			if (image == null) {
				if (name == null || texture == null) return false;
				image = new ImageData(name, texture);
				texture.setName(name);
				_protoKeys.put(name, image);
			}
			image.length++;
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
				chat += "resource=" + bit.resource + ",len=" + bit.length + "\n";
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
import org.web.sdk.gpu.texture.BaseTexture;

class ImageData {
	
	public var length:int;
	public var resource:String;
	public var texture:BaseTexture;
	
	public function ImageData(resource:String, texture:BaseTexture, leng:int = 0)
	{
		this.resource = resource;
		this.texture = texture;
		this.length = leng;
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