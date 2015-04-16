package org.web.sdk.display.paddy.covert
{
	import org.web.sdk.log.Log;
	import org.web.sdk.global.HashMap;
	import org.web.sdk.display.paddy.covert.SmartRender;
	/**
	 *暗暗的管理
	 */
	final internal class SecretlyManager
	{
		private static var _ins:SecretlyManager;
		
		internal static function gets():SecretlyManager
		{
			if (null == _ins) _ins = new SecretlyManager;
			return _ins;
		}
		
		//全局定义
		private var _protoKeys:HashMap = new HashMap;
		
		//不用了的从这里删除下
		public function register(texture:SmartRender):void
		{
			if (texture == null) throw Error("无效材质");
			const name:String = texture.getResName();
			var tx:SmartRender = getResource(name);
			if (tx == null) {
				Log.log(this).debug("注册资源:", name, texture);
				_protoKeys.put(name, texture);
			}else {
				if (tx != texture) throw Error("相同名称的材质: name=" + name);
			}
		}
		
		//释放一个纹理
		public function remove(resName:String):void 
		{
			_protoKeys.remove(resName);
			Log.log(this).debug("释放资源:", resName);
		}
		
		//是否存在这张照片
		public function hasRes(resName:String):Boolean
		{
			return _protoKeys.isKey(resName);
		}
		
		public function getResource(name:String):SmartRender
		{
			return _protoKeys.getValue(name);
		}
		
		//取所有的资源
		public function getIterator():Vector.<SmartRender>
		{
			return Vector.<SmartRender>(_protoKeys.getValues());
		}
		
		//释放整个模块
		public function free():void
		{
			var vector:Vector.<SmartRender> = getIterator();
			_protoKeys.clear();
			for each(var tx:SmartRender in vector) tx.dispose();
		}
		
		public function toString():String 
		{
			var vector:Vector.<SmartRender> = getIterator();
			var chat:String = '[图片资源库:\n';
			var tx:SmartRender;
			for (var i:int = 0; i < vector.length; i++)
			{
				chat += "resName=" + vector[i].getResName() + ",len=" + vector[i].length + "\n";
			}
			chat += "->总共:" + vector.length + "]";
			return chat;
		}
		
		//ends
	}
}