package game.socket 
{
	import game.consts.CmdDefined;
	import game.socket.core.CommandRequest;
	import org.web.sdk.net.socket.core.ServerRequest;
	
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
		//ends
	}

}