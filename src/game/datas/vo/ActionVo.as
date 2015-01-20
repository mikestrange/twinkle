package game.datas.vo 
{
	import org.web.sdk.FrameWork;
	
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
		
		public function setData(po:int, x:int, y:int, lefx:int, lefy:int, offx:uint = 0, offy:uint = 0):void
		{
			this.point = po;
			this.x = x < 0?0:x;
			this.y = y < 0?0:y;
			var dx:int = lefx - offx;
			var dy:int = lefy - offy;
			this.leftx = dx < 0?0:dx;
			this.lefty = dy < 0?0:dy;
			this.width = FrameWork.winWidth + offx;
			this.height = FrameWork.winHeight + offy;
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