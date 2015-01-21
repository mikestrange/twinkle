package game.socket.keep 
{
	import game.consts.CmdDefined;
	import org.web.sdk.net.socket.core.ServerRequest;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.socket.ServerSocket;
	
	public class HeartBeat extends ServerRespond 
	{
		
		override public function action(event:RespondEvented):void 
		{
			super.action(event);
			if (event.socket) {
				//收到心跳包直接回执
				event.socket.sendNoticeRequest(new ServerRequest(CmdDefined.HEART_BEAT));
			}
		}
		//ends
	}

}