package game.socket.logic 
{
	import game.consts.CmdDefined;
	import game.consts.NoticeDefined;
	import game.socket.core.CommandRequest;
	import org.web.sdk.net.socket.core.ServerRequest;
	import org.web.sdk.system.inter.IMessage;
	
	/*
	 * 登陆游戏
	 * */
	public class LogicRequest extends CommandRequest 
	{
		
		public function LogicRequest() 
		{
			super(CmdDefined.LOGIC_GAME, 0);
		}
		
		override protected function plumage(message:Object = null):void 
		{
			super.plumage(message);
			var arr:Array = message as Array;
			writeInt(arr[0]);
			writeString();
			writeString(arr[1]);
			writeInt(arr[0]);
			writeInt(arr[0]);
			writeInt(arr[0]);
		}
		
		override protected function test(message:IMessage):void 
		{
			message.sendMessage(NoticeDefined.ON_LOGIC);
		}
		
		//ends
	}

}