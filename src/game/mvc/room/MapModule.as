package game.mvc.room 
{
	import game.consts.CmdDefined;
	import game.consts.ModuleType;
	import game.mvc.room.net.result.EnterResult;
	import game.mvc.room.net.result.QuitResult;
	import game.mvc.room.net.result.MoveResult;
	import game.mvc.room.net.result.StandResult;
	import org.web.sdk.net.socket.SocketModule;
	
	public class MapModule extends SocketModule 
	{
		
		public function MapModule() 
		{
			super(ModuleType.MAP);
		}
		
		override protected function about_register():void 
		{
			super.about_register();
			addRespond(CmdDefined.ENTER_MAP, EnterResult);
			addRespond(CmdDefined.QUIT_MAP, QuitResult);
			addRespond(CmdDefined.MOVE_TO, MoveResult);
			addRespond(CmdDefined.STAND_HERE, StandResult);
		}
		
		private static var _ins:MapModule;
		public static function gets():MapModule
		{
			if (null == _ins) _ins = new MapModule;
			return _ins;
		}
		//ends
	}

}