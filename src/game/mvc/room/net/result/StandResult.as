package game.mvc.room.net.result 
{
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.socket.RespondEvented;
	
	public class StandResult extends ServerRespond 
	{
		public var player:PlayerObj;
		
		override public function action(cmd:uint, event:RespondEvented = null):void 
		{
			super.action(cmd, event);
			player = new PlayerObj();
			player.uid = event.readInt();
			player.type = event.readShort();	//角色类型
			player.usn = event.readString();
			player.level = event.readShort();
			player.point = event.readByte();
			player.x = event.readShort();
			player.y = event.readShort();
			//
			sendMessage(NoticeDefined.ON_STAND_HERE);
		}
		//ends
	}

}