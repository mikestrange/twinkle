package game.socket.logic 
{
	import org.web.sdk.net.utils.FtpRead;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.utils.FtpWrite;
	
	public class LogicHandler extends ServerRespond 
	{
		
		override protected function analyze(proto:FtpRead):void 
		{
			//
			var logged:Boolean = proto.readBoolean();
			if (!logged) {
				var error:int = proto.readShort();
				trace("登陆失败:"+error);
			}else {
				var name:String = proto.readString();
				var password:String = proto.readString();
				trace("成功进入游戏	name:"+name,",pass:",password);
			}
		}
		//ends
	}

}