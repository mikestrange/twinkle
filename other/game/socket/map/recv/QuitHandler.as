package game.socket.map.recv 
{
	import game.consts.NoticeDefined;
	import game.datas.obj.PlayerObj;
	import game.datas.SelfData;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.utils.FtpRead;
	
	public class QuitHandler extends ServerRespond 
	{
		public var player:PlayerObj;
		
		override protected function analyze(proto:FtpRead):void 
		{
			player = new PlayerObj;
			player.uid = proto.readInt();
		}
		
		override public function getMessage():Object 
		{
			if (isdebug) player = PlayerObj.gets();
			return player;
		}
		//ends
	}

}