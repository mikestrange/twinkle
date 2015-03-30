package game.datas.vo 
{
	import flash.geom.Rectangle;
	
	public class ActionVo 
	{
		public var mapid:int;
		public var point:int;
		public var x:int;
		public var y:int;
		public var leftx:int;
		public var lefty:int;
		public var width:int;
		public var height:int;
		
		public function setData(po:int, x:int, y:int, rect:Rectangle, offx:uint = 0, offy:uint = 0):void
		{
			this.point = po;
			this.x = x < 0?0:x;
			this.y = y < 0?0:y;
			this.leftx = rect.x;
			this.lefty = rect.y;
			this.width = rect.width + offx;
			this.height = rect.height + offy;
			//trace(x, y, leftx, lefty, width, height);
		}
		
		private static var _ins:ActionVo;
		
		public static function gets():ActionVo
		{
			if (_ins == null) _ins = new ActionVo;
			return _ins;
		}
		
		
		//ends
	}

}