package org.web.sdk.tool.cse 
{
	import flash.utils.ByteArray;

	public final class McryptEncryption 
	{
		public static const _BYTE_LENG_:int = 8;
		//密钥长度 可以自行设置
		public static const _KEY_MAX_:uint = 16;
		//必要的字符
		internal static const KEY_MAP:String = "ABCDEFGHIGKLMNOPQRSTUVWXYZabcdefghigklmnopqrstuvwxyz0123456789{}[]~!@#$%^&*()-=+<>?:.";
		//二段法则
		internal static const MTS:uint = 0x77;
		internal static const LSM:uint = 0xaa;
		
		//错位加密 ->1235和4678交换位置
		internal static function ciphertext(num:int):int
		{
			return (num >> 7 & 1) << 4 | (num >> 6 & 1) << 2 | (num >> 5 & 1) << 1 |
			(num >> 4 & 1) << 7 | (num >> 3 & 1) | (num >> 2 & 1) << 6 | 
			(num >> 1 & 1)<<5 | (num & 1)<<3;
		}
		
		//简单的对称互换 1234/5678
		internal static function ciphertextSym(num:int):int
		{
			return (num & 0xf) << 4 | num >> 4;
		}

		//随机取1个字符 1-255
		internal static function getMessy():int
		{
			return Math.random() * 255 + 1>> 0;
			var ran:int = Math.random() * KEY_MAP.length >> 0;
			return KEY_MAP.charCodeAt(ran);
		}
		
		//把一个字节打乱  打乱两个自序  a 的前leng位和B的后leng位调换位置
		//这方法比较完美
		internal static function messyBytes(num:int = 1, code:int = 1, leng:int = 3):Array
		{
			var a3:int = (num >> (_BYTE_LENG_ - leng)) & (0xff >> (_BYTE_LENG_ - leng));
			var a5:int = num  & (0xff >> leng);
			var b5:int = (code >> leng) & (0xff >> leng);
			var b3:int = code & (0xff >> (_BYTE_LENG_ - leng));  
			var a:int = (b3 << (_BYTE_LENG_ - leng)) | a5;
			var b:int = (b5 << leng) | a3;
			return [a, b];
		}
		
		
		//ends
	}
}