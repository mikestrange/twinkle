package org.web.sdk.loader 
{
	import org.web.sdk.loader.interfaces.ILoader;
	import org.web.sdk.loader.loads.*;
	
	final public class LoadSetup 
	{
		//定义类型
		private static const SWF_EXP:RegExp =/.swf|.mp3/ig;
		private static const IMG_EXP:RegExp =/.jpg|.png|.jpeg|.bmp/ig;
		private static const TXT_EXP:RegExp =/.ini|.txt|.xml/ig;
		
		private static var sheetLoader:Array = [];
		private static const LIM:int = -1;
		
		//默认定义
		public static function setDefault():void
		{
			setLoader(LoadEvent.SWF, SwfLoader);
			setLoader(LoadEvent.IMG, ImgLoader);
			setLoader(LoadEvent.TXT, TextLoader);
			setLoader(LoadEvent.BYTE, ByteLoader);
		}
		
		public static function setSwfLoader(className:Class):void
		{
			setLoader(LoadEvent.SWF, className);
		}
		
		public static function setImgLoader(className:Class):void
		{
			setLoader(LoadEvent.IMG, className);
		}
		
		public static function setTextLoader(className:Class):void
		{
			setLoader(LoadEvent.TXT, className);
		}
		
		public static function setBaseLoader(className:Class):void
		{
			setLoader(LoadEvent.BYTE, className);
		}
		
		//自定义
		public static function setLoader(type:int, className:Class):void
		{
			sheetLoader[type] = className;
		}
		
		//取类型
		public static function getUrlType(url:String):int
		{
			if (url.search(SWF_EXP) != LIM) return LoadEvent.SWF;
			if (url.search(IMG_EXP) != LIM) return LoadEvent.IMG;
			if (url.search(TXT_EXP) != LIM) return LoadEvent.TXT;
			return LoadEvent.BYTE;
		}
		
		public static function createLoader(type:int):ILoader
		{
			return new sheetLoader[type] as ILoader;
		}
		
		//end
	}

}