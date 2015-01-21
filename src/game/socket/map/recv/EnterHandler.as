package game.socket.map.recv 
{
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import game.datas.SelfData;
	import org.web.sdk.net.utils.FtpRead;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.handler.RespondEvented;
	
	public class EnterHandler extends ServerRespond 
	{
		public var mapId:int;
		public var self:Boolean;
		public var player:PlayerObj;
		
		//只有用户在进入地图的时候才回调
		override protected function readByte(proto:FtpRead):void 
		{
			mapId = proto.readShort();
			var uid:int = proto.readInt();			//
			var type:int = proto.readShort();		//角色类型
			var usn:String = proto.readString();		//
			var level:int = proto.readShort();		//
			var point:int = proto.readByte();		//方向	
			var x:int = proto.readShort();
			var y:int = proto.readShort();
			
			if (uid == SelfData.gets().uid) {
				self = true;
				PlayerObj.gets().update(uid, usn, x, y, point, level, type);
			}else {
				player = new PlayerObj();
				player.update(uid, usn, x, y, point, level, type);
			}
		}
		
		override public function getMessage():Object 
		{
			if (player == null) {
				mapId = 3001;
				self = true;
				PlayerObj.gets().update(SelfData.gets().uid, "ts1", 1000, 1000);
			}
			return super.getMessage();
		}
		
		
		//ends
	}
}