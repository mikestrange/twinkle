package org.web.sdk.context 
{
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import org.web.sdk.FrameWork;
	import org.web.sdk.load.LoadEvent;
	/**
	 *域的管理
	 */
	public class ContextManager 
	{
		
		private static var _ins:ContextManager;
		
		public static function create():ContextManager
		{
			if (null == _ins) _ins = new ContextManager;
			return _ins;
		}
		
		//主域
		private var _typeKeys:Object = { };
		private var _app:ApplicationDomain;
		
		public function ContextManager(domain:ApplicationDomain = null)
		{
			if (domain == null) domain = ApplicationDomain.currentDomain;
			_app = domain;
		}
		
		//swf加载,这里没有使用开始
		public function load(url:String, complete:Function, data:Object = null, context:LoaderContext = null):void
		{
			FrameWork.perfectLoader.addWait(url, LoadEvent.SWF, context).addRespond(complete, data);
		}
		
		//注册一个类型  不是Loader不会被注册
		public function share(url:String, context:ResourceContext):void
		{
			if (null == context) throw Error("不存在的域：" + url);
			if (undefined == _typeKeys[url]) {
				_typeKeys[url] = context;
				trace("保存一个域名：", url, context);
			}
		}
		
		public function has(url:String):Boolean
		{
			return undefined != _typeKeys[url];
		}
		
		public function getContext(url:String):ResourceContext
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
				var apk:ResourceContext = getContext(url);
				if (apk) Obj = apk.getClass(name);
			}
			if (Obj) return new Obj;
			trace("不存在的定义:", url, name);
			return null;
		}
		
		//ends
	}
}