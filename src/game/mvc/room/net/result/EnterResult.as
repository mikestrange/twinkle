package game.mvc.room.net.result 
{
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import game.datas.SelfData;
	import org.web.sdk.net.socket.base.FtpRead;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.socket.RespondEvented;
	
	public class EnterResult extends ServerRespond 
	{
		public var mapId:int;
		public var self:Boolean = false;
		public var player:PlayerObj;
		
		//只有用户在进入地图的时候才回调
		override public function action(cmd:uint, event:RespondEvented = null):void 
		{
			super.action(cmd, event);
			mapId = event.readShort();
			var uid:int = event.readInt();			//
			var type:int = event.readShort();		//角色类型
			var usn:String = event.readString();		//
			var level:int = event.readShort();		//
			var point:int = event.readByte();		//方向	
			var x:int = event.readShort();
			var y:int = event.readShort();
			
			if (uid == SelfData.gets().uid) {
				self = true;
				PlayerObj.gets().update(uid, usn, x, y, point, level, type);
			}else {
				player = new PlayerObj();
				player.update(uid, usn, x, y, point, level, type);
			}
			sendMessage(NoticeDefined.ON_ENTER_MAP);
		}	
		//ends
	}
}