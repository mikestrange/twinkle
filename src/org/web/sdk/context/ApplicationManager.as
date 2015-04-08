package org.web.sdk.context 
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import org.web.sdk.log.Log;
	/**
	 *域的管理
	 */
	public class ApplicationManager 
	{
		
		private static var _ins:ApplicationManager;
		
		public static function create():ApplicationManager
		{
			if (null == _ins) _ins = new ApplicationManager;
			return _ins;
		}
		
		//主域
		private var _typeKeys:Object = { };
		private var _app:ApplicationDomain;
		
		public function ApplicationManager(domain:ApplicationDomain = null)
		{
			if (domain == null) domain = ApplicationDomain.currentDomain;
			_app = domain;
		}
		
		//注册一个类型  不是Loader不会被注册
		public function share(url:String, context:AppDomain):void
		{
			if (null == context) throw Error("不存在的域：" + url);
			if (undefined == _typeKeys[url]) {
				_typeKeys[url] = context;
				Log.log(this).info("保存一个域名：", url, context);
			}
		}
		
		public function has(url:String):Boolean
		{
			return undefined != _typeKeys[url];
		}
		
		public function getContext(url:String):AppDomain
		{
			return _typeKeys[url];
		}
		
		//取资源
		public function getAsset(name:String, url:String = null):Object
		{
			var Obj:Class = null;
			if (url == null) {
				if (_app.hasDefinition(name)) {
					Obj = _app.getDefinition(name) as Class;
				}
			}else {
				var apk:AppDomain = getContext(url);
				if (apk) Obj = apk.getClass(name);
			}
			if (Obj) return new Obj;
			Log.log(this).error("不存在的定义:", url, name);
			return null;
		}
		
		//ends
	}
}