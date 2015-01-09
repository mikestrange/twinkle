package game.socket.core 
{
	import org.web.sdk.net.socket.core.ServerRequest;
	import org.web.sdk.net.socket.inter.ISocket;
	import org.web.sdk.system.com.ICommand;
	import org.web.sdk.system.events.Evented;
	/**
	 * 服务器的命令
	 */
	public class CommandRequest extends ServerRequest implements ICommand 
	{
		
		public function CommandRequest(cmd:uint, type:int = 0) 
		{
			super(cmd, type);
		}
		
		/* INTERFACE org.web.sdk.system.com.ICommand */
		public function execute(event:Evented):void 
		{
			var socket:ISocket = event.client as ISocket;
			if(socket) socket.sendNoticeRequest(this, event.data);
		}
		//ends
	}
}