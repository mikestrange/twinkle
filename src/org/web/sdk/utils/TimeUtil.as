package org.web.sdk.utils 
{

	public class TimeUtil
	{
		public static const yearText:String = "年";
        public static const monthText:String = "月";
        public static const dayText:String = "天";
        public static const hourText:String = "小时";
        public static const minuteText:String = "分钟";
        public static const secondText:String = "秒";
		//
		private static var $date:Date = new Date();
		
		//这里传入的是一个毫秒或者日期
		public static function format(value:*, type:int = 0) : String
        {
            var times:Date = null;
            if (value is Date){
				times = value;
            }else {
                $date.time = Number(value);
                times = $date;
            }
			
			var year:String = String(times.fullYear);
			var month:String = CharUtil.formatNumberWithZero((times.month + 1), 2);
			var date:String = CharUtil.formatNumberWithZero(times.date, 2);
			var hours:String = CharUtil.formatNumberWithZero(times.hours, 2);
			var minutes:String = CharUtil.formatNumberWithZero(times.minutes, 2);
			var seconds:String = CharUtil.formatNumberWithZero(times.seconds, 2);
			var msec:String = CharUtil.formatNumberWithZero(times.milliseconds, 3);
			//char
			//var dat:String = year + "/" + month + "/" + date;
			//var tm:String = hours + ":" + minutes + ":" + seconds;
            switch(type)
            {
				//显示年/月/日 时:分:秒
				case 0:return year + "-" + month + "-" + date;
				//显示年/月/日 时:分:秒.毫秒
                case 1:return year + "/" + month + "/" + date + " " + hours + ":" + minutes + ":" + seconds + "." + msec;
				//显示年-月-日
                case 2:return year + "/" + month + "/" + date;
				case 3:return year + "/" + month + "/" + date + " " + hours + ":" + minutes + ":" + seconds;
				case 4:return hours + ":" + minutes;
			}
            return times.toString();
        }
		
		//当前时间（毫秒）
		public static function getTime():Number
		{
			return new Date().getTime();
		}
		
		//-1表示时间未到达或者时间已经过去
		//一个时间到当前时间的差值  如果当前时间大于这个时间，那么就显示为-1;
		//false,表示时间剩余，true表示时间流失
		public static function floatTime(other:Number, befor:Boolean = false):int 
		{
			if (!befor) {
				//这里是当前时间到指定的时间距离多少时间秒
				if (getTime() < other) return other - getTime();
			}else {
				//这里取的是以前的时间距离现在过去了多长时间
				if (getTime() > other) return getTime() - other;
			}
			return -1;
		}
		
		//00:00:00  这里是秒来计算的 (时分秒);
		public static function getTimeForChar(time:Number) : String
        {
            var secon:int = time % 60;
            var min:int = time / 60 % 60;
            var hour:int = time / (60 * 60) | 0;	   // (% 24)不会大于24小时
			var days:int = time / (24 * 60 * 60) | 0; //天
            return hoursToStr(hour) + ":" + hoursToStr(min) + ":" + hoursToStr(secon);
        }
		
		public static function hoursToStr(time:Number) : String
        {
            return time < 10 ? ("0" + time) : String(time);
        }
		
		//ends
	}

}