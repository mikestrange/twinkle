package game.socket.map.recv 
{
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.utils.FtpRead;
	
	public class StandHandler extends ServerRespond 
	{
		public var player:PlayerObj;
		
		override protected function readByte(proto:FtpRead):void 
		{
			player = new PlayerObj();
			player.uid = proto.readInt();
			player.type = proto.readShort();	//角色类型
			player.usn = proto.readString();
			player.level = proto.readShort();
			player.point = proto.readByte();
			player.x = proto.readShort();
			player.y = proto.readShort();
		}
		//ends
	}

}