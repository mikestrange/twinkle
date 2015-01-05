package org.web.sdk.pool 
{
	import flash.display.Loader;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...  swf->分为主界面swf和人物动画swf
	 * 1，界面swfs（字库，素材，各个界面） 动态加载不卸载
	 * 2，人物动画swfs（人物，怪物，npc，技能，） (动态加载，集合卸载)
	 * ..具体实现，请扩展本类
	 */
	public class Resource 
	{
		private static var _ins:Resource;
		
		public static function create():Resource
		{
			if (null == _ins) _ins = new Resource;
			return _ins;
		}
		
		//整列
		private var _typeKeys:Object = { };
		private var _appdomain:ApplicationDomain;
		
		public function Resource(domain:ApplicationDomain = null)
		{
			if (domain == null) domain = ApplicationDomain.currentDomain;
			_appdomain = domain;
		}
		
		//注册一个类型  不是Loader不会被注册
		public function share(url:String, loader:Loader):void
		{
			if (undefined == _typeKeys[url]) _typeKeys[url] = loader.contentLoaderInfo.applicationDomain;
		}
		
		public function has(url:String):Boolean
		{
			return undefined != _typeKeys[url];
		}
		
		//取一个app-----这里根据单个取
		public function getAppDomain(url:String):ApplicationDomain
		{
			var appdomain:ApplicationDomain = _typeKeys[url];
			if (appdomain) return appdomain;
			return null;
		}
		
		//这里是主程序域取元素
		protected function getClassByName(name:String):Class 
		{
			if (_appdomain.hasDefinition(name)) return _appdomain.getDefinition(name) as Class;
			return null;
		}
		
		public function getAsset(className:String, url:String = null):*
		{
			var Movie:Class = null;
			if (url == null) {
				Movie = getClassByName(className);
			}else {
				var apk:ApplicationDomain = getAppDomain(url);
				if (apk && apk.hasDefinition(className)) Movie = apk.getDefinition(className) as Class;
			}
			if (Movie) return new Movie;
			return null;
		}
		
		//ends
	}
}