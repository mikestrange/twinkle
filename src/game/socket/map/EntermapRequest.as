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
			writeShort(data.mapid);		//mapid
			writeByte(data.point);		//point
			writeShort(data.x);			//x
			writeShort(data.y);
			writeShort(data.leftx);			//x
			writeShort(data.lefty);
			writeShort(data.width);		//len
			writeShort(data.height);
		}
		
		private var index:int = 0;
		//测试的时候会进入这里
		override protected function debug(data:Object):void 
		{
			sendTest(CmdDefined.ENTER_MAP);
			//
			Clock.step(1500, call, 0, CmdDefined.STAND_HERE);
			//Clock.step(50000, quit, 1, CmdDefined.QUIT_MAP);
			//Clock.step(1000, call, 0, CmdDefined.MOVE_TO);
			//Clock.step(1000, call, 0, CmdDefined.ACTION_ROLE);
		}
		
		private function call(cmd:int):void
		{
			/*if (index > 2000) return;
			for (var i:int = 0; i < 300; i++) {
				index++;
				sendTest(cmd);
			}*/
			
			sendTest(cmd);
		}
		
		private function quit(cmd:int):void
		{
			trace("执行了什么:", cmd)
			Clock.kill(call);
			sendTest(cmd);
		}
		
		//ends
	}
}