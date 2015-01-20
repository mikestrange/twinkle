package game.mvc.cmd 
{
	import game.consts.CmdDefined;
	import game.consts.NoticeDefined;
	import game.socket.map.recv.*;
	import game.socket.world.LogicResult;
	import org.web.sdk.net.socket.handler.RespondConverter;
	import org.web.sdk.net.socket.handler.RespondEvented;
	
	public class GameManager extends RespondConverter 
	{
		private var dos:Boolean = false;
		
		override public function register():void 
		{
			if (dos) return;
			dos = true;
			super.register();
			//比如如果在其他地方注册了心跳包，那么如果之前没有处理，就可以在那里处理
			registerHandler(CmdDefined.HEART_BEAT, handler);	
			registerHandler(CmdDefined.LOGIC_GAME, handler);
			//
			registerHandler(CmdDefined.ENTER_MAP, handler);
			registerHandler(CmdDefined.QUIT_MAP, handler);
			registerHandler(CmdDefined.MOVE_TO, handler);
			registerHandler(CmdDefined.STAND_HERE, handler);
		}
		
		private function handler(event:RespondEvented):void
		{
			switch(event.getCmd())
			{
				case CmdDefined.LOGIC_GAME:
					event.invoke(NoticeDefined.ON_LOGIC, new LogicResult);
					break;
				case CmdDefined.ENTER_MAP:
					event.invoke(NoticeDefined.ON_ENTER_MAP, new EnterResult);
					break;
				case CmdDefined.QUIT_MAP:
					event.invoke(NoticeDefined.ON_QUIT_MAP, new QuitResult);
					break;
				case CmdDefined.MOVE_TO:
					event.invoke(NoticeDefined.ON_USER_MOVE, new MoveResult);
					break;
				case CmdDefined.STAND_HERE:
					event.invoke(NoticeDefined.ON_STAND_HERE, new StandResult);
					break;	
			}
		}
		
		override public function destroy():void 
		{
			if (!dos) return;
			dos = false;
			super.destroy();
		}
		
		//
		private static var _ins:GameManager;
		public static function gets():GameManager
		{
			if (null == _ins) _ins = new GameManager;
			return _ins;
		}
		//end
	}

}