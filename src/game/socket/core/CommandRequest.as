package game.socket.core 
{
	import game.consts.CmdDefined;
	import game.GameGlobal;
	import org.web.sdk.net.socket.core.ServerRequest;
	import org.web.sdk.net.handler.CmdManager;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.interfaces.INetwork;
	import org.web.sdk.system.com.ICommand;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.inter.IMessage;
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
			if (GameGlobal.isDebug) {
				debug(event.data);
			}else {
				var socket:INetwork = event.client as INetwork;
				if(socket) socket.sendNoticeRequest(this, event.data);
			}
		}
		
		//测试的时候进入
		protected function debug(data:Object):void
		{
			
		}
		
		protected function sendTest(cmd:Number):void
		{
			CmdManager.dispatchRespond(new RespondEvented(cmd, null, null, true));
		}
		//ends
	}
}