package org.web.sdk.loader 
{
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
		//
		public var url:String;
		public var type:String;
		public var data:* = undefined;
		//
		public var isOver:Boolean = false;
		public var isError:Boolean = false;
		//
		public function LoadEvent(type:String, url:String, data:*= undefined)
		{
			this.type = type;
			this.url = url;
			this.data = data;
			this.isOver = (type == COMPLETE || type == ERROR);
			this.isError = (type == ERROR);
		}
		
		//end
	}

}