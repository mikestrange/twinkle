package org.web.sdk.gpu.shader 
{
	import org.web.sdk.log.Log;
	import org.web.sdk.utils.HashMap;
	/*
	 * 渲染器管理资源集合
	 * */
	public class ShaderManager 
	{	
		private static var _ins:ShaderManager;
		
		public static function gets():ShaderManager
		{
			if (_ins == null) _ins = new ShaderManager;
			return _ins;
		}
		
		//
		private var hash:HashMap;
		//引用计数
		public function ShaderManager() 
		{
			hash = new HashMap;
		}
		
		//直接创建
		/*
		public static function create(value:CryRenderer):Boolean
		{
			return gets().share(value);
		}*/
		
		public static function has(code:String):Boolean
		{
			return gets().hash.isKey(code);
		}
		
		public static function dispose(code:String):void
		{
			if (!has(code)) return;
			gets().getConductor(code).free();
		}
		
		//保存一个
		internal function share(value:CryRenderer):Boolean
		{
			var code:String = value.getCode();
			if (!hash.isKey(code)) {
				hash.put(code, value);
				Log.log(this).debug("成功建立资源库:", value, ",code=", code);
				return true;
			}
			Log.log(this).debug("成功建立库失败:", value, ",code=", code);
			return false;
		}
		
		internal function remove(value:CryRenderer):void
		{
			hash.remove(value.getCode());
			Log.log(this).debug("成功删除资源库:", value, ",code=", value.getCode());
		}
		
		//根据编码取得
		public function getConductor(code:String):CryRenderer
		{
			return hash.getValue(code);
		}
		
		//ends
	}
}
