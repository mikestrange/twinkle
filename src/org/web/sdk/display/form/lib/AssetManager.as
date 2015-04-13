package org.web.sdk.display.form.lib
{
	import org.web.sdk.display.form.lib.ResRender;
	import org.web.sdk.log.Log;
	import org.web.sdk.global.HashMap;
	/**
	 * ...
	 *动态下载静态贴图
	 */
	public class AssetManager
	{
		private static var _ins:AssetManager;
		
		internal static function gets():AssetManager
		{
			if (null == _ins) _ins = new AssetManager;
			return _ins;
		}
		
		//全局定义
		private var _protoKeys:HashMap = new HashMap;
		
		//不用了的从这里删除下
		public function register(texture:ResRender):void
		{
			if (texture == null) throw Error("无效材质");
			const name:String = texture.getResName();
			var tx:ResRender = getTexture(name);
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
		
		public function getTexture(name:String):ResRender
		{
			return _protoKeys.getValue(name);
		}
		
		//取所有的资源
		public function getIterator():Vector.<ResRender>
		{
			return Vector.<ResRender>(_protoKeys.getValues());
		}
		
		//释放整个模块
		public function free():void
		{
			var vector:Vector.<ResRender> = getIterator();
			_protoKeys.clear();
			for each(var tx:ResRender in vector) tx.dispose();
		}
		
		public function toString():String 
		{
			var vector:Vector.<ResRender> = getIterator();
			var chat:String = '[图片资源库:\n';
			var tx:ResRender;
			for (var i:int = 0; i < vector.length; i++)
			{
				chat += "libName=" + vector[i].getResName() + ",len=" + vector[i].length + "\n";
			}
			chat += "->总共:" + vector.length + "]";
			return chat;
		}
		
		//ends
	}
}