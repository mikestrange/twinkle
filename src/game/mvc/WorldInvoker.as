package game.mvc 
{
	import game.consts.NoticeDefined;
	import game.mvc.net.request.LogicRequest;
	import org.web.sdk.system.com.Invoker;
	import org.web.sdk.system.inter.IMessage;
	
	public class WorldInvoker extends Invoker 
	{
		override public function register(msg:IMessage):void 
		{
			super.register(msg);
			addOnlyCommand(NoticeDefined.SET_LOGIC, LogicRequest);
		}
		
		//ends
	}

}