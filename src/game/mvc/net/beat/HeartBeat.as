package game.mvc.net.beat 
{
	import game.consts.CmdDefined;
	import org.web.sdk.net.socket.core.ServerRequest;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.socket.RespondEvented;
	import org.web.sdk.net.socket.ServerSocket;
	
	public class HeartBeat extends ServerRespond 
	{
		
		override public function action(cmd:uint, event:RespondEvented = null):void 
		{
			super.action(cmd, event);
			//收到心跳包直接回执
			event.getSocket().sendNoticeRequest(new ServerRequest(CmdDefined.HEART_BEAT));
		}
		//ends
	}

}