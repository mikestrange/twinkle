package game.datas.module 
{
	/**
	 * 地图信息 模块
	 */
	public class MapModule 
	{
		public var mapName:String;
		public var mapId:String;
		public var itemList:Array = [];
		public var npcList:Array = [];
		public var roleList:Array = [];
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//
		private static var _ins:MapModule;
		public static function gets():MapModule
		{
			if (_ins == null) _ins = new MapModule;
			return _ins;
		}
		//ends
	}

}