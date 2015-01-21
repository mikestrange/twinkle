package game.socket.map.recv 
{
	import game.consts.NoticeDefined;
	import game.datas.obj.PlayerObj;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.utils.FtpRead;
	
	public class MoveHandler extends ServerRespond 
	{
		public var player:PlayerObj;
		//
		override protected function analyze(proto:FtpRead):void 
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
		
		override public function getMessage():Object 
		{
			if (this.isdebug) {
				var ran:int = Math.random() * 1000 >> 0;
				player = new PlayerObj();
				player.uid = ran;
				player.type = 0
				player.usn = "测试人员" + ran;
				player.level = 10;
				player.point = Math.floor(Math.random() * 8);
				player.x = Math.floor(Math.random() * 1000);
				player.y = Math.floor(Math.random() * 1000);
			}
			return player;
		}
		//ends
	}

}