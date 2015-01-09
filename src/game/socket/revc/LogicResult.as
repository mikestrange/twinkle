package game.socket.revc 
{
	import org.web.sdk.net.socket.base.FtpRead;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.socket.handler.RespondEvented;
	
	public class LogicResult extends ServerRespond 
	{
		
		override public function action(event:RespondEvented):Boolean 
		{
			super.action(event);
			var logged:Boolean = event.readBoolean();
			if (!logged) {
				var error:int = event.readShort();
				trace("登陆失败:"+error);
			}else {
				var name:String = event.readString();
				var password:String = event.readString();
				trace("成功进入游戏	name:"+name,",pass:",password);
			}
			return true;
		}
		//ends
	}

}