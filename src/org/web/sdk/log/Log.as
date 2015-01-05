package org.web.sdk.log 
{
	import flash.net.FileReference;
	import org.web.sdk.utils.NameUtil;
	import org.web.sdk.utils.TimeUtil;
	
	public final class Log 
	{
		public static const DEBUG:int = 1;
        public static const INFO:int = 2;
		public static const WARN:int = 3;
		public static const ERROR:int = 4;
		//不同等级不同颜色
		private static const DEBUG_COLOR:String = "#ccccc";
		private static const INFO_COLOR:String = "#ffffff";
		private static const WARN_COLOR:String = "#ffff00";
		private static const ERROR_COLOR:String = "#ff0000";
		public static const COLORS:Array = ['#000000', DEBUG_COLOR, INFO_COLOR, WARN_COLOR, ERROR_COLOR];
		public static const LITE_TEXT:Array = ['[right]', '[debug]' , '[info]', '[warn]', '[error]'];
		//
		private static const DEFAULT_NAME:String = "[ NONE ]";			//默认日志属性
		//保存为日志文件
		private static var pureLogs:Vector.<LogData> = new Vector.<LogData>;
		private static const LOG_LENG:int = 10000;
		//
		public static var SHARE_LOG:Boolean = true;
		//
		public static const HTML:String = 'html';
		public static const TEXT:String = 'text';
		
		//[log object]
		private var className:String;
		
		public function debug(...args):void
		{
			output(DEBUG, args);
		}
		
		public function info(...args):void
		{
			output(INFO, args);
		}
		
		public function error(...args):void
		{
			output(ERROR, args);
		}
		
		public function warn(...args):void
		{
			output(WARN, args);
		}
		
		protected function output(value:int, args:Array):void
		{
			var chat:String;
			if (className == null) chat = DEFAULT_NAME;
			else chat = "[ " + this.className + " ] ";
			//next
            for (var i:int = 0; i < args.length; i++) {
				if (i == args.length - 1) chat += args[i] + "";
				else chat += args[i] + " , ";
			}
			//输出
			trace(chat);
			//是否保存日子，直接文本保存
			if (SHARE_LOG) addLog(new LogData(value, chat, TimeUtil.getTime()));
		}
		
		private static function addLog(info:LogData):void
		{
			pureLogs.push(info);
			if (pureLogs.length > LOG_LENG) pureLogs.shift();
		}
		
		//取所有日志 不同格式,最好不用及时打印,不长时间打印
		public static function getLogs(type:String = 'text'):String
		{
			var debug:String = '';
			for (var i:int = 0; i < pureLogs.length; i++)
			{
				if (type == HTML) {
					debug += pureLogs[i].html;
				}else if (type == TEXT) {
					debug += pureLogs[i].text;
				}
			}
			return debug;
		}
		
		public static function clear():void
		{
			while (pureLogs.length) pureLogs.shift();
		}
		
		public static function length():int
		{
			return pureLogs.length;
		}
		
		//保存日志文件
		private static var _file:FileReference;
		
		public static function save(fileName:String='log.txt'):void
		{
			if (null == _file) _file = new FileReference;
			_file.save(getLogs(), fileName);
		}
		
		//***********
		private static var _log:Log;
		
		public static function log(target:Object = null):Log
		{
			if (null == _log) _log = new Log;
			_log.className = null;
			if (target) _log.className = NameUtil.getClassName(target);
            return _log;
		}
		
		//ends
	}
}
