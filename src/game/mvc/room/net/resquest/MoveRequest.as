package game.mvc.room.net.resquest 
{
	import game.consts.CmdDefined;
	import game.consts.NoticeDefined;
	import game.datas.vo.ActionVo;
	import game.mvc.net.BaseRequest;
	
	public class MoveRequest extends BaseRequest 
	{
		
		public function MoveRequest() 
		{
			super(CmdDefined.MOVE_TO, 0);
		}
		
		// map_id,point,x,y,lenx,leny,
		override protected function plumage(message:Object = null):void 
		{
			super.plumage(message);
			var data:ActionVo = message as ActionVo;
			writeByte(data.point);			//point
			writeShort(data.x);				//x
			writeShort(data.y);
			writeShort(data.leftx);			//x
			writeShort(data.lefty);
			writeShort(data.width);			//len
			writeShort(data.height);
		}
		//ends
	}

}