package org.web.sdk.net.socket.base 
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;

	public class FtpRead
	{
		public static const BYTE:int = 2;
		public static const ZORE:int = 0;
		public static const TRUE:int = 1;
		
		public static function create(input:IDataInput = null):FtpRead
		{
			return new FtpRead(input);
		}
		
		//object
		private var Input:IDataInput;
		
		public function FtpRead(input:IDataInput)
		{
			if (null == input) input = new ByteArray;
			Input = input;
		}
		
		public function set endian(value:String):void
		{
			Input.endian = value;
		}
		
		public function get length():uint
		{
			return Input.bytesAvailable;
		}
		
		//8
		public function readBoolean():Boolean
		{
			return Input.readByte() == TRUE;
		}
		
		//8
		public function readByte():int
		{
			return Input.readByte();
		}
		
		//+8
		public function readUnsignedByte():uint
		{
			return Input.readUnsignedByte();
		}
		
		//16
		public function readShort():int
		{
			return Input.readShort();
		}
		
		//+16
		public function readUnsignedShort():uint
		{
			return Input.readUnsignedShort();
		}
		
		//32
		public function readInt():int
		{
			return Input.readInt();
		}
		
		//+32
		public function readUint():uint
		{
			return Input.readUnsignedInt();
		}
		
		//64
		public function readNumber():Number
		{
			var str:String = '';
			var a:int = readUnsignedByte();
			var b:int = readUnsignedByte();
			var c:int = readUnsignedByte();
			var d:int = readUnsignedByte();
			//后32
			var e:int = readUnsignedByte();
			var f:int = readUnsignedByte();
			var g:int = readUnsignedByte();
			var h:int = readUnsignedByte();
			
			if (Input.endian == ByteSystem.BIG_ENDIAN) {
				//大端读出
				str = coinLeng(a) + coinLeng(b) + coinLeng(c) + coinLeng(d) + coinLeng(e) + coinLeng(f) + coinLeng(g) + coinLeng(h);
			}else {
				//小端读出
				str = coinLeng(h) + coinLeng(g) + coinLeng(f) + coinLeng(e) + coinLeng(d) + coinLeng(c) + coinLeng(b) + coinLeng(a);
			}
			const long:int = 64;
			if (str.charAt(ZORE) == "1" && str.length == long)
			{
				//正则替换0和1
				str = str.replace(/1/g, 't');
				str = str.replace(/0/g, '1');
				str = str.replace(/t/g, '0');
				return -parseInt(str, BYTE) - 1;
			}
			return parseInt(str, BYTE);
		}
		
		public function readString(type:String = 'utf-8'):String
		{
			const size:uint = readUnsignedShort();
			if (size == ZORE) return '';
			return Input.readMultiByte(size, type);
		}
		
		public static function coinLeng(byte:Number, leng:int = 8):String
		{
			var str:String = byte.toString(2);
			var index:int = str.length;
			var file:String = '';
			while (index < leng)
			{
				file +=  '0';
				index++;
			}
			str = file + str;
			return str;
		}
		//ends
	}

}