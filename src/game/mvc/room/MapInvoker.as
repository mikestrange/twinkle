package game.mvc.room 
{
	import game.consts.NoticeDefined;
	import game.mvc.room.net.resquest.EnterMapReqeust;
	import game.mvc.room.net.resquest.QuitMapRequest;
	import game.mvc.room.net.resquest.MoveRequest;
	import game.mvc.room.net.resquest.StandRequest;	
	import org.web.sdk.system.com.Invoker;
	import org.web.sdk.system.inter.IMessage;
	
	public class MapInvoker extends Invoker 
	{
		
		override public function register(msg:IMessage):void 
		{
			super.register(msg);
			addOnlyCommand(NoticeDefined.ENTER_MAP, EnterMapReqeust);
			addOnlyCommand(NoticeDefined.QUIT_MAP, QuitMapRequest);
			addOnlyCommand(NoticeDefined.USER_MOVE, MoveRequest);
			addOnlyCommand(NoticeDefined.STAND_HERE, StandRequest);
		}
		
		//enmds
	}

}