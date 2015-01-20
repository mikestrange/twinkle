package game.socket.map 
{
	import game.consts.CmdDefined;
	import game.datas.SelfData;
	import game.socket.core.CommandRequest;
	
	public class StandRequest extends CommandRequest 
	{
		
		public function StandRequest() 
		{
			super(CmdDefined.STAND_HERE);
		}
		
		// map_id,point,x,y,lenx,leny,
		override protected function plumage(message:Object = null):void 
		{
			super.plumage(message);
			writeInt(SelfData.gets().uid);
		}
		//ends
	}

}