package game.mvc.room.net.resquest 
{
	import game.consts.CmdDefined;
	import game.datas.SelfData;
	import game.mvc.net.BaseRequest;
	
	public class StandRequest extends BaseRequest 
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