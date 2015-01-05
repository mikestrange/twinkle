package game.mvc 
{
	import game.consts.CmdDefined;
	import game.consts.ModuleType;
	import game.mvc.net.beat.HeartBeat;
	import game.mvc.net.result.LogicResult;
	import org.web.sdk.net.socket.SocketModule;
	
	public class WorldModule extends SocketModule 
	{
		public function WorldModule()
		{
			super(ModuleType.WORLD);
		}
		
		override protected function about_register():void 
		{
			super.about_register();
			addRespond(CmdDefined.LOGIC_GAME, LogicResult);
			addRespond(CmdDefined.HEART_BEAT, HeartBeat);
		}
		
		private static var _ins:WorldModule;
		public static function gets():WorldModule
		{
			if (null == _ins) _ins = new WorldModule;
			return _ins;
		}
		//ends
	}

}