package game.mvc.room.net.result 
{
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import game.datas.SelfData;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.socket.RespondEvented;
	
	public class QuitResult extends ServerRespond 
	{
		public var player:PlayerObj;
		
		override public function action(cmd:uint, event:RespondEvented = null):void 
		{
			super.action(cmd, event);
			player = new PlayerObj;
			player.uid = event.readInt();
		}
		
		//ends
	}

}