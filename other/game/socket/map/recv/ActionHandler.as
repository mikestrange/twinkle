package game.socket.map.recv 
{
	import game.datas.obj.ActionObj;
	import org.web.sdk.net.socket.core.ServerRespond;
	import org.web.sdk.net.utils.FtpRead;
	
	public class ActionHandler extends ServerRespond 
	{
		private var data:ActionObj;
		
		override protected function analyze(proto:FtpRead):void 
		{
			data = new ActionObj;
		}
		
		override public function getMessage():Object 
		{
			if (isdebug) {
				data = new ActionObj;
				data.type = 1;
				//data.uid = 1001;
				data.uid = Math.floor(Math.random() * 5000);
			}
			return data;
		}
		
		///ends
	}

}