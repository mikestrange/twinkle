package game.socket.map 
{
	import game.consts.CmdDefined;
	import game.datas.vo.ActionVo;
	import game.socket.core.CommandRequest;
	import org.web.sdk.net.handler.CmdManager;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.system.inter.IMessage;
	import org.web.sdk.tool.Clock;
	
	public class EntermapRequest extends CommandRequest 
	{
		
		public function EntermapRequest() 
		{
			super(CmdDefined.ENTER_MAP, 0);
		}
		
		// map_id,point,x,y,lenx,leny,
		override protected function plumage(message:Object = null):void 
		{
			super.plumage(message);
			var data:ActionVo = message as ActionVo;
			/*
			writeShort(data.mapid);		//mapid
			writeByte(data.point);		//point
			writeShort(data.x);			//x
			writeShort(data.y);
			writeShort(data.width);		//len
			writeShort(data.height);
			*/
			writeShort(3001);		//mapid
			writeByte(4);			//point
			writeShort(100);		//x
			writeShort(100);
			writeShort(0);			//x
			writeShort(0);
			writeShort(500);		//len
			writeShort(300);
		}
		
		//测试的时候会进入这里
		override protected function debug(data:Object):void 
		{
			sendTest(CmdDefined.ENTER_MAP);
			//
			Clock.step(1000, call, 0);
		}
		
		private function call():void
		{
			sendTest(CmdDefined.STAND_HERE);
		}
		
		//ends
	}
}