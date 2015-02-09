/** 
 *org.web.sdk.load542540443@qq.com 
 *@version 1.0.0 
 * 创建时间：2013-12-5 下午11:46:04 
 **/ 
package org.web.sdk.load 
{
	import flash.system.LoaderContext;
	//下载回执
	public class LoadEvent 
	{
		//下载类型
		public static const BYTE:int = 0;	//默认下载
		public static const SWF:int = 1;	
		public static const TXT:int = 2;	//xml
		public static const IMG:int = 3;
		//
		public static const COMPLETE:String = 'complete';
		public static const ERROR:String = 'error';
		public static const OPEN:String = 'open';
		public static const OPRESS:String = 'opress';
		public static const CLOSED:String = 'closed';
		//_target传过来的数据
		private var _target:Object;
		private var _url:String;
		private var _eventType:String;
		private var _type:int;
		private var _data:Object;
		private var _context:LoaderContext;
		//
		public function LoadEvent(target:Object, url:String, context:LoaderContext, eventType:String, data:Object = null, type:int = 0)
		{
			this._target = target;
			this._url = url;
			this._eventType = eventType;
			this._type = type;
			this._data = data;
			this._context = context;
		}
		
		public function get data():Object
		{
			return _data;
		}
		
		public function get target():Object
		{
			return _target;
		}
		
		public function get eventType():String
		{
			return _eventType;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get url():String
		{
			return _url;
		}
		
		public function get context():LoaderContext
		{
			return _context;
		}
		//ends
	}
}