package game.socket.revc.map 
{
	import game.consts.CmdDefined;
	import game.datas.vo.ActionVo;
	import game.socket.core.CommandRequest;
	
	public class EnterMapReqeust extends CommandRequest 
	{
		
		public function EnterMapReqeust() 
		{
			super(CmdDefined.ENTER_MAP, 0);
		}
		
		// map_id,point,x,y,lenx,leny,
		override protected function plumage(message:Object = null):void 
		{
			super.plumage(message);
			var data:ActionVo = message as ActionVo;
			/*
			writeShort(data.mapid);		//mapid
			writeByte(data.point);		//point
			writeShort(data.x);			//x
			writeShort(data.y);
			writeShort(data.width);		//len
			writeShort(data.height);
			*/
			writeShort(3001);		//mapid
			writeByte(4);		//point
			writeShort(100);			//x
			writeShort(100);
			writeShort(0);			//x
			writeShort(0);
			writeShort(500);		//len
			writeShort(300);
		}
		
		//ends
	}
}