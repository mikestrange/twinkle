package game.socket.map.recv 
{
	import game.consts.NoticeDefined;
	import game.datas.obj.EntermapObj;
	import game.datas.obj.PlayerObj;
	import game.datas.SelfData;
	import org.web.sdk.net.utils.FtpRead;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.handler.RespondEvented;
	
	public class EnterHandler extends ServerRespond 
	{
		public var data:EntermapObj;
		
		//只有用户在进入地图的时候才回调
		override protected function analyze(proto:FtpRead):void 
		{
			data = new EntermapObj;
			data.mapId = proto.readShort();
			var uid:int = proto.readInt();			//
			var type:int = proto.readShort();		//角色类型
			var usn:String = proto.readString();		//
			var level:int = proto.readShort();		//
			var point:int = proto.readByte();		//方向	
			var x:int = proto.readShort();
			var y:int = proto.readShort();
			
			data.player.update(uid, usn, x, y, point, level, type);
			if(data.player.isself()) PlayerObj.gets().update(uid, usn, x, y, point, level, type);
		}
		
		override public function getMessage():Object 
		{
			if (this.isdebug) {
				data = new EntermapObj;
				data.mapId = 3001;
				data.player.update(SelfData.gets().uid, "ts1", 1000, 1000);
				if(data.player.isself()) PlayerObj.gets().update(SelfData.gets().uid, "ts1", 1000, 1000);
			}
			return data;
		}
		
		
		//ends
	}
}