package org.web.sdk.display.asset
{
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.log.Log;
	import org.web.sdk.utils.HashMap;
	//
	import org.web.sdk.beyond_challenge;
	use namespace beyond_challenge
	/**
	 * ...
	 *动态下载静态贴图
	 */
	public class Assets
	{
		private static var _ins:Assets;
		
		internal static function gets():Assets
		{
			if (null == _ins) _ins = new Assets;
			return _ins;
		}
		
		//全局定义
		private var _protoKeys:HashMap = new HashMap;
		
		//不用了的从这里删除下
		public function register(texture:LibRender):void
		{
			if (texture == null) throw Error("无效材质");
			const name:String = texture.name;
			var tx:LibRender = getTexture(name);
			if (tx == null) {
				Log.log(this).debug("注册资源:", name, texture);
				_protoKeys.put(name, texture);
			}else {
				if (tx != texture) throw Error("相同名称的材质: name=" + name);
			}
		}
		
		//释放一个纹理
		public function remove(libName:String):void 
		{
			_protoKeys.remove(libName);
			Log.log(this).debug("释放资源:", libName);
		}
		
		//是否存在这张照片
		public function has(libName:String):Boolean
		{
			return _protoKeys.isKey(libName);
		}
		
		public function getTexture(name:String):LibRender
		{
			return _protoKeys.getValue(name);
		}
		
		//取所有的资源
		public function getIterator():Vector.<LibRender>
		{
			return Vector.<LibRender>(_protoKeys.getValues());
		}
		
		//释放整个模块
		public function free():void
		{
			var vector:Vector.<LibRender> = getIterator();
			_protoKeys.clear();
			for each(var tx:LibRender in vector) tx.dispose();
		}
		
		public function toString():String 
		{
			var vector:Vector.<LibRender> = getIterator();
			var chat:String = '[图片资源库:\n';
			var tx:LibRender;
			for (var i:int = 0; i < vector.length; i++)
			{
				chat += "libName=" + vector[i].name + ",len=" + vector[i].length + "\n";
			}
			chat += "->总共:" + vector.length + "]";
			return chat;
		}
		
		//ends
	}
}