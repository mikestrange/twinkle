package game.socket.revc.map.recv 
{
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.socket.handler.RespondEvented;
	
	public class MoveResult extends ServerRespond 
	{
		public var player:PlayerObj;
		
		//
		override public function action(event:RespondEvented):Boolean 
		{
			super.action(event);
			player = new PlayerObj();
			player.uid = event.readInt();
			player.type = event.readShort();	//角色类型
			player.usn = event.readString();
			player.level = event.readShort();
			player.point = event.readByte();
			player.x = event.readShort();
			player.y = event.readShort();
			return true;
		}
		//ends
	}

}