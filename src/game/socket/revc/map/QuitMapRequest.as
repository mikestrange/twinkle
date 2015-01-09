package game.socket.revc.map 
{
	import game.consts.CmdDefined;
	import game.consts.NoticeDefined;
	import game.datas.SelfData;
	import game.socket.core.CommandRequest;
	
	public class QuitMapRequest extends CommandRequest 
	{
		
		public function QuitMapRequest() 
		{
			super(CmdDefined.QUIT_MAP);
		}
		
		// map_id,point,x,y,lenx,leny,
		override protected function plumage(message:Object = null):void 
		{
			super.plumage(message);
			writeInt(SelfData.gets().uid);
		}
		//EMDS
	}

}