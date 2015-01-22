package org.web.sdk.utils 
{
	public class StringUtils 
	{
		private static var regexp:RegExp;
		//屏蔽字符
		public static function setRegExp(chat:String):void
		{
			if (null == regexp) regexp = new RegExp(chat, 'ig');
		}
		
		public static function shield(chat:String):String
		{
			return chat.replace(regexp, '*');
		}
		
		//给一个数字字符墙面补0
		public static function formatNumber(number:Number, leng:int = 32, radix:int = 10):String
        {
			var value:String = number.toString(radix);
            if (value.length >= leng) return value;
			const ZEOR:String = "0";
            var char:String = "";
            var length:int = leng;
            while (length > 0)
            {
                char = char + ZEOR;
                --length;
            }
            char = char + value;
            return char.substr(char.length - leng);
        }
		
		//截断 一个长度，小于这个长度则不计算
        public static function cutRight(char:String, length:int = 1) : String
        {
            if (char.length <= length) return char;
            return char.substr(char.length - length);
        }
		
		//10000 转换成 100,000
		public static function replaceWithComma(value:Number, rep:String = ",") : String
        {
            var index:int = 0;
            var topArr:Array = null;
            var topStr:String = null;
            var arr:Array =  String(value).split(".");
            var crr:Array = String(arr[0]).split("");
            var dsp:int = String(arr[0]).split("").length % 3 == 0 ? (3) : (crr.length % 3);
            var str:String = String(arr[0]).substr(0, dsp);
            var length:int = crr.length;
            index = dsp;
            while (index < length)
            {
                str = str + (rep + crr[index] + crr[(index + 1)] + crr[index + 2]);
                index = index + 3;
            }
            if (arr.length >= 2)
            {
                topArr = String(arr[1]).split("");
                topStr = "";
                length = topArr.length;
                index = 0;
                while (index < length)
                {
                    
                    if (index != 0)
                    {
                        topStr = topStr + rep;
                    }
                    topStr = topStr + topArr[index];
                    if ((index + 1) < length)
                    {
                        topStr = topStr + topArr[(index + 1)];
                    }
                    if (index + 2 < length)
                    {
                        topStr = topStr + topArr[index + 2];
                    }
                    index = index + 3;
                }
                return str + "." + topStr;
            }
            return str;
        }
		//ends
	}
}