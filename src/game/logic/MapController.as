package game.logic 
{
	import flash.ui.Keyboard;
	import game.consts.CmdDefined;
	import game.consts.ModuleType;
	import game.consts.NoticeDefined;
	import game.datas.obj.ActionObj;
	import game.datas.obj.EntermapObj;
	import game.datas.obj.PlayerObj;
	import game.socket.map.*;
	import game.socket.map.recv.*;
	import game.ui.map.WorldMap;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.net.socket.ServerSocket;
	import org.web.sdk.system.com.Invoker;
	import org.web.sdk.system.core.Controller;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.inter.IMessage;
	import org.web.sdk.system.key.KeyManager;
	
	public class MapController extends Controller 
	{
		private var _ismap:Boolean = false;	
		private var _map:WorldMap;
		
		override public function launch(notice:IMessage):void 
		{
			super.launch(notice);
			//注册命令  一个命令器只关心自己注册的事务
			var _invoker:Invoker = new Invoker(notice);
			_invoker.addOnlyCommand(NoticeDefined.ENTER_MAP, EntermapRequest);
			_invoker.addOnlyCommand(NoticeDefined.QUIT_MAP, QuitMapRequest);
			_invoker.addOnlyCommand(NoticeDefined.USER_MOVE, MoveRequest);
			_invoker.addOnlyCommand(NoticeDefined.STAND_HERE, StandRequest);
			notice.addInvoker("map", _invoker);
			//可以设置监听所有端口
		}
		
		override public function free():void 
		{
			super.free();
			getMessage().removeInvoker("map");
			if(_ismap) _map.free();
		}
		
		override public function getSecretlyNotices():Array 
		{
			return [NoticeDefined.ON_ENTER_MAP, NoticeDefined.ON_QUIT_MAP, NoticeDefined.ON_USER_MOVE, NoticeDefined.ON_STAND_HERE,
				NoticeDefined.ON_ACTION_ROLE];
		}
		
		//责任处理
		override public function dutyEvented(event:Evented):void 
		{
			switch(event.name)
			{
				case NoticeDefined.ON_ENTER_MAP:
					enterMap(event.data as EntermapObj);
					break;
				case NoticeDefined.ON_QUIT_MAP:
					if(_ismap) quitMap(event.data as PlayerObj);
					break;
				case NoticeDefined.ON_USER_MOVE:
					if(_ismap) _map.move(event.data as PlayerObj);
					break;
				case NoticeDefined.ON_STAND_HERE:
					if(_ismap) _map.stop(event.data as PlayerObj);
					break;
				case NoticeDefined.ON_ACTION_ROLE:
					if(_ismap) actionRole(event.data as ActionObj);
					break;
			}
		}
		
		private function enterMap(data:EntermapObj):void
		{
			if (data.player.isself()) {
				if (_ismap) return;
				_ismap = true;
				_map = new WorldMap()
				_map.showMap(data.mapId);
			}else {
				if(_ismap) _map.createPlayer(data.player);
			}
		}
		
		private function quitMap(player:PlayerObj):void
		{
			if (player.isself()) {
				_ismap = false;
				_map.free();
				_map = null;
				Multiple.collection(10);
			}else {
				_map.removeUser(player.uid);
			}
		}
		
		private function actionRole(obj:ActionObj):void
		{
			_map.action(obj);
		}
		
		//ends
	}
}