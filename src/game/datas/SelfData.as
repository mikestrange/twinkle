package game.datas 
{
	public class SelfData 
	{
		private static var _ins:SelfData;
		public static function gets():SelfData
		{
			if (null == _ins) _ins = new SelfData;
			return _ins;
		}
		
		public var mapid:int = -1;
		public var uid:int;
		public var openid:String;
		public var usn:String;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		public var password:String;
		public var dynamic_pass:String;
		
		//ends
	}

}