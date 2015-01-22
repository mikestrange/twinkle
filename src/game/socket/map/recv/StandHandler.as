package game.socket.map.recv 
{
	import game.consts.NoticeDefined;
	import game.datas.obj.PlayerObj;
	import game.datas.SelfData;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.utils.FtpRead;
	
	public class StandHandler extends ServerRespond 
	{
		public var player:PlayerObj;
		
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
		
		private static var index:int = 0;
		override public function getMessage():Object 
		{
			if (isdebug) {
				var ran:int = index++;// Math.random() * 5000 >> 0;
				if (ran == SelfData.gets().uid) return PlayerObj.gets();
				player = new PlayerObj();
				player.uid = ran;
				player.type = 0
				player.usn = "测试" + ran;
				player.level = 10;
				player.point = Math.floor(Math.random() * 8);
				player.x =100+ Math.floor(Math.random() * 500);
				player.y =100+ Math.floor(Math.random() * 400);
			}
			return player;
		}
		
		//ends
	}

}