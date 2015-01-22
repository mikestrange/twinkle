package org.web.sdk.log 
{
	//日志信息
	import org.web.sdk.utils.TimeUtils;
	import org.web.sdk.log.Log;
	
	public class LogData 
	{
		public var type:int;
		public var chat:String;
		public var time:Number;	//1970格林志时间
		
		public function LogData(type:int, chat:String, time:Number) 
		{
			this.type = type;
			this.chat = chat;
			this.time = time;
		}
		
		public function getTimeForChat(index:int = 1):String
		{
			return TimeUtils.format(time, index);
		}
		
		public function get html():String
		{
			return "<font size='14' color='" + Log.COLORS[type] + "'>" + chat + "</font><br>";
		}
		
		public function get text():String
		{
			return getTimeForChat() + Log.LITE_TEXT[type] + chat  + "\n";
		}
		//ends
	}

}