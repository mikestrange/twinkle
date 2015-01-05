package org.web.sdk.net.socket.base 
{
	import flash.utils.ByteArray;
	import flash.utils.IDataOutput;
	
	public class FtpWrite 
	{
		public static const BYTE:int = 2;
		public static const ZORE:int = 0;
		public static const TRUE:int = 1;
		
		//快速建立
		public static function create(output:IDataOutput = null):FtpWrite
		{
			return new FtpWrite(output);
		}
		
		//写入流
		private var Output:IDataOutput;
		private var leng:uint = 0;
		
		public function FtpWrite(output:IDataOutput = null)
		{
			if (output == null) output = new ByteArray;
			Output = output;
		}
		
		public function get length():uint
		{
			return leng;
		}
		
		public function set endian(value:String):void
		{
			Output.endian = value;
		}
		
		//可以重复使用
		public function getBytes():ByteArray
		{
			var byte:ByteArray = new ByteArray;
			byte.writeBytes(Output as ByteArray, 0, leng);
			byte.position = 0;
			return byte;
		}
		
		//1
		public function writeBoolean(bool:Boolean):void
		{
			Output.writeByte(bool ? 1 : 0);
			leng += 1;
		}
		
		//8
		public function writeByte(byte:int):void
		{
			Output.writeByte(byte);
			leng += 1;
		}
		
		//16
		public function writeShort(value:int):void
		{
			Output.writeShort(value);
			leng += 2;
		}
		
		//32
		public function writeInt(value:int):void
		{
			Output.writeInt(value);
			leng += 4;
		}
		
		//+32
		public function writeUint(value:uint):void
		{
			Output.writeUnsignedInt(value);
			leng += 4;
		}
		
		//64
		public function writeNumber(value:Number):void
		{
			const must:Boolean = value < 0;
			if (must) value = -(value+1);
			const len:int = 64;
			var chat:String = FtpRead.coinLeng(value, len);
			if (must) {
				chat = chat.replace(/1/g, '2');
				chat = chat.replace(/0/g, '1');
				chat = chat.replace(/2/g, '0');
			}
			//前32
			var tp:int = 0;
			if (Output.endian == ByteSystem.BIG_ENDIAN) {
				//大端写入
				while (tp < len) {
					value = parseInt(chat.substr(tp, 8), 2);
					Output.writeByte(value);
					tp += 8;
				}
			}else {
				//小端写入
				tp = len - 8;
				while (tp >= 0) {
					value = parseInt(chat.substr(tp, 8), 2);
					Output.writeByte(value);
					tp -= 8;
				}
			}
			leng += 8;
		}
			
		//字符串
		public function writeString(chat:String = null, type:String = 'utf-8'):void
		{
			if (chat == null) {
				this.writeShort(ZORE);
			}else {
				const byte:ByteArray = new ByteArray();
				byte.writeMultiByte(chat, type);
				this.writeShort(byte.length);
				Output.writeMultiByte(chat, type);
				leng += byte.length;
				byte.clear();
			}
		}
		
		public function clear():void
		{
			leng = ZORE;
			ByteArray(Output).clear();
		}
		
		//ends
	}
}