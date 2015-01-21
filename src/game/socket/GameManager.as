package game.socket 
{
	import game.consts.CmdDefined;
	import game.consts.NoticeDefined;
	import game.socket.map.recv.*;
	import game.socket.logic.LogicHandler;
	import org.web.sdk.net.handler.RespondConverter;
	import org.web.sdk.net.handler.RespondEvented;
	/*
	 * socket cmd callblack
	 * */
	public class GameManager extends RespondConverter 
	{
		override public function getCmdList():Array 
		{
			return [CmdDefined.HEART_BEAT, CmdDefined.LOGIC_GAME,
			CmdDefined.ENTER_MAP, CmdDefined.QUIT_MAP, CmdDefined.MOVE_TO, CmdDefined.STAND_HERE];
		}
		
		override protected function actionHandler(event:RespondEvented):void 
		{
			switch(event.cmd)
			{
				case CmdDefined.LOGIC_GAME:
					event.invoke(NoticeDefined.ON_LOGIC, new LogicHandler);
					break;
				case CmdDefined.ENTER_MAP:
					event.invoke(NoticeDefined.ON_ENTER_MAP, new EnterHandler);
					break;
				case CmdDefined.QUIT_MAP:
					event.invoke(NoticeDefined.ON_QUIT_MAP, new QuitHandler);
					break;
				case CmdDefined.MOVE_TO:
					event.invoke(NoticeDefined.ON_USER_MOVE, new MoveHandler);
					break;
				case CmdDefined.STAND_HERE:
					event.invoke(NoticeDefined.ON_STAND_HERE, new StandHandler);
					break;	
			}
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