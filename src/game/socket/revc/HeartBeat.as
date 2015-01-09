package game.socket.revc 
{
	import game.consts.CmdDefined;
	import org.web.sdk.net.socket.core.ServerRequest;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.socket.handler.RespondEvented;
	import org.web.sdk.net.socket.ServerSocket;
	
	public class HeartBeat extends ServerRespond 
	{
		
		override public function action(event:RespondEvented):Boolean 
		{
			super.action(event);
			//收到心跳包直接回执
			event.getSocket().sendNoticeRequest(new ServerRequest(CmdDefined.HEART_BEAT));
			return true;
		}
		//ends
	}

}