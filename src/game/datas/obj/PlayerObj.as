package game.datas.obj 
{
	import game.datas.SelfData;
	import org.web.rpg.astar.Node;
	
	public class PlayerObj 
	{
		public var type:int;		//角色类型
		public var uid:int;			//id
		public var usn:String;		//名称
		public var level:int;		//等级
		public var x:int;
		public var y:int;
		public var point:int = 4;
		
		public function update(uid:int, usn:String, x:int, y:int, point:int = 4, level:int = 0, type:int = 0):void
		{
			this.uid = uid;
			this.usn = usn;
			this.x = x;
			this.y = y;
			this.point = point;
			this.level = level;
			this.type = type;
		}
		
		public function get url():String
		{
			return "http://127.0.0.1/game/asset/ui/001_player.swf";
		}
		
		public function isself():Boolean
		{
			return uid == SelfData.gets().uid;
		}
		
		//
		private static var _ins:PlayerObj;
		
		public static function gets():PlayerObj
		{
			if (null == _ins) _ins = new PlayerObj;
			return _ins;
		}
		
		//ends
	}

}