package game.socket.map.recv 
{
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import game.datas.SelfData;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.socket.handler.RespondEvented;
	
	public class QuitResult extends ServerRespond 
	{
		public var player:PlayerObj;
		
		override public function action(event:RespondEvented):Boolean 
		{
			super.action(event);
			player = new PlayerObj;
			player.uid = event.readInt();
			return true;
		}
		
		//ends
	}

}