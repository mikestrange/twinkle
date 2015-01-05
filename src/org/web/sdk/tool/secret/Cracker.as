package org.web.sdk.tool.secret 
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.display.Loader;
	/*加密*/
	public class Cracker 
	{
		//密钥
		protected static const KEY:String = "please do not crack this,no person, i will kill you";
		//中间符号
		protected static const KEY_DOUBLE:String="Don't talk to strangers";
		//base64
		protected static const KEY_END:String="yOe5+8Tjxsa94sHLo6zEx8O0uafPssTjo6zE48rH0ru49rP2yau1xLPM0PLUsaOh";

		//二进制加密
		public static function encrypt(data:*):ByteArray
		{
			return arithmetic(data as ByteArray);
		}

		//二进制解密
		public static function decode(data:*):ByteArray
		{
			return arithmetic(data as ByteArray);
		}

		//算法
		protected static function arithmetic(data:ByteArray):ByteArray
		{
			var coy:ByteArray=data as ByteArray;

			var keys:ByteArray=getKey();

			var byte:ByteArray = new ByteArray();
			//
			var leng:int=Math.min(keys.length,coy.length);
		
			for (var i:int = 0; i < leng; i ++) {
				byte.writeByte(coy[i] ^ keys[i]);
			}
			keys.clear();
	
			if (leng < coy.length) byte.writeBytes(coy, leng);
			
			return byte;
		}

		//密钥
		protected static function getKey():ByteArray
		{
			var keyBytes:ByteArray = new ByteArray();
			keyBytes.writeUTF(KEY + KEY_DOUBLE + KEY_END);
			return keyBytes;
		}

		//swf里面破解
		public static function FilesCrypter(byte:ByteArray):Loader
		{
			var loader:Loader=new Loader;
			loader.loadBytes(decode(byte));
			return loader;
		}
		
		//ends
	}
}