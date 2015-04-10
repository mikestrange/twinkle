package org.web.sdk.load 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import org.web.sdk.context.AppDomain;
	
	public class LoadEvent 
	{
		public static const COMPLETE:String = 'complete';	//下载完成
		public static const ERROR:String = 'error';			//下载错误
		public static const OPEN:String = 'open';			//打开下载
		public static const OPRESS:String = 'opress';		//下载监督
		//下载类型
		public static const BYTE:int = 0;	//默认下载
		public static const SWF:int = 1;	
		public static const TXT:int = 2;	//xml
		public static const IMG:int = 3;
		//不允许个人操作
		public var url:String;
		public var type:String;
		public var data:* = undefined;
		//结束或者错误
		public var isOver:Boolean;
		public var isError:Boolean;
		public var isOpen:Boolean;
		//程序域
		private var _domain:AppDomain;
		
		public function LoadEvent(type:String, url:String, data:*= undefined)
		{
			this.type = type;
			this.url = url;
			this.data = data;
			this.isOver = (type == COMPLETE || type == ERROR);
			this.isError = (type == ERROR);
			this.isOpen = (type == OPEN);
		}
		
		public function get bitmapdata():BitmapData
		{
			return data as BitmapData;
		}
		
		public function get loader():Loader
		{
			return data as Loader;
		}
		
		public function get string():String
		{
			return data as String;
		}
		
		public function get xml():XML
		{
			return new XML(data as String);
		}
		
		//Loader域
		public function getDomain():AppDomain
		{
			if (null == _domain) _domain = new AppDomain(data); 
			return _domain;
		}
		
		//end
	}

}