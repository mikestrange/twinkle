package org.web.sdk.tool.secret 
{
	import flash.utils.ByteArray;

	public class FloatPass 
	{
		private static var $cipher:ByteArray;
		
		//二次元密文  发送到服务器的也是一个被加密的二进制
		public static function get cospaCipher():ByteArray
		{
			if ($cipher) {
				$cipher.position = 0;
				return $cipher;
			}
			return null;
		}
		
		public static function set cospaCipher(value:ByteArray):void
		{
			if ($cipher) $cipher.clear();
			$cipher = value;
		}
		
		//原文变成译文，PS:加密后传送给后端->后端通过解析密文来开通客服端权限
		public static function crackEncrypt(byte:ByteArray):ByteArray
		{
			var code:int; //原始值
			var cipher:ByteArray = sorkToBytes(byte);
			var data:ByteArray = new ByteArray;
			while (cipher.bytesAvailable) {
				code = cipher.readByte();
				code = McryptEncryption.ciphertext(code) ^ McryptEncryption.MTS  & 0xff;
				code = McryptEncryption.ciphertextSym(code) ^ McryptEncryption.LSM  & 0xff;
				data.writeByte(code);
			}
			data.position = 0;
			return data;
		}
		
		//密码翻译成原文
		public static function translationEncrypt(byte:ByteArray):ByteArray
		{
			byte.position = 0;
			var data:ByteArray = new ByteArray;
			var code:int;
			while (byte.bytesAvailable) {
				code = byte.readByte();
				code = McryptEncryption.ciphertextSym((code ^ McryptEncryption.LSM) & 0xff);
				code = McryptEncryption.ciphertext((code ^ McryptEncryption.MTS) & 0xff);
				data.writeByte(code);
			}
			data.position = 0;
			return versaSorkToBytes(data);
		} 
		
		//加密使用
		protected static function sorkToBytes(byte:ByteArray):ByteArray
		{
			if (byte.length != McryptEncryption._KEY_MAX_) throw Error("格式不对！");
			var buff:Array = [];
			byte.position = 0;
			while (byte.bytesAvailable) {
				buff.push(byte.readByte());
			}
			byte.clear();
			var code:int;
			var other:int;
			var result:Array;
			var leng:int = 0;
			var index:int = -1;
			var data:ByteArray = new ByteArray;
			var curr:int;
			while (++index < buff.length)
			{
				code = buff[index];
				index % 2 ? leng = 3 : leng = 5;
				curr = index + 1;
				if (curr >= buff.length) curr = 0;
				//
				other = buff[curr];
				result = McryptEncryption.messyBytes(code, other, leng);
				buff[index] = result[0];
				buff[curr] = result[1];
			}
			index = -1;
			while (++index <buff.length) {
				data.writeByte(buff[index]);
			}
			data.position = 0;
			return data;
		}
		
		//解密使用
		protected static function versaSorkToBytes(byte:ByteArray):ByteArray
		{
			if (byte.length != McryptEncryption._KEY_MAX_) throw Error("格式不对！");
			
			var buff:Array = [];
			byte.position = 0;
			while (byte.bytesAvailable) {
				buff.push(byte.readByte());
			}
			byte.clear();
			var code:int;
			var other:int;
			var leng:int;
			var result:Array;
			var data:ByteArray = new ByteArray;
			var index:int = buff.length;
			var curr:int;
			while (--index >= 0)
			{
				code = buff[index];
				index % 2 ? leng = 3 : leng = 5;
				curr = index + 1;
				if (curr >= buff.length) curr = 0;
				//
				other = buff[curr];
				result = McryptEncryption.messyBytes(code, other, leng);
				buff[index] = result[0];
				buff[curr] = result[1];
			}
			index = -1;
			while (++index < buff.length) {
				data.writeByte(buff[index]);
			}
			data.position = 0;
			return data;
		}
		
		//服务端传过来的应该是未加密的明文，通过客服端传送密文和后台对比
		public static function getCipher():ByteArray
		{
			var index:int = -1;
			var byte:ByteArray = new ByteArray;
			while (++index < McryptEncryption._KEY_MAX_) {
				byte.writeByte(McryptEncryption.getMessy());
			}
			byte.position = 0;
			return byte;
		}
		
		//ends
	}

}