package game.mvc.room 
{
	import flash.ui.Keyboard;
	import game.consts.CmdDefined;
	import game.consts.ModuleType;
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import game.mvc.room.net.resquest.*;
	import game.mvc.room.net.result.*;
	import game.ui.map.WorldMap;
	import org.web.sdk.net.socket.ServerSocket;
	import org.web.sdk.net.socket.SocketModule;
	import org.web.sdk.system.com.Invoker;
	import org.web.sdk.system.core.Controller;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.system.inter.IMessage;
	import org.web.sdk.system.key.KeyManager;
	
	public class MapController extends Controller 
	{
		private var _ismap:Boolean = false;	
		private var _invoker:Invoker;
		private var _result:SocketModule;
		
		override public function launch(notice:IMessage):void 
		{
			super.launch(notice);
			//注册命令
			_invoker = new Invoker;
			_invoker.register(notice);
			_invoker.addOnlyCommand(NoticeDefined.ENTER_MAP, EnterMapReqeust);
			_invoker.addOnlyCommand(NoticeDefined.QUIT_MAP, QuitMapRequest);
			_invoker.addOnlyCommand(NoticeDefined.USER_MOVE, MoveRequest);
			_invoker.addOnlyCommand(NoticeDefined.STAND_HERE, StandRequest);
			//注册回调
			_result = new SocketModule(ModuleType.MAP);
			_result.addRespond(CmdDefined.ENTER_MAP, EnterResult);
			_result.addRespond(CmdDefined.QUIT_MAP, QuitResult);
			_result.addRespond(CmdDefined.MOVE_TO, MoveResult);
			_result.addRespond(CmdDefined.STAND_HERE, StandResult);
			//
			KeyManager.keyListener(Keyboard.F8, "enterF8", onKeyDown);
		}
		
		private function onKeyDown(...rest):void
		{
			ServerSocket.socket.sendNotice(NoticeDefined.QUIT_MAP);
			ServerSocket.socket.sendNotice(NoticeDefined.ENTER_MAP);
		}
		
		override public function free():void 
		{
			super.free();
			_result.destroy();
			_invoker.quit();
			WorldMap.gets().free();
		}
		
		override public function getSecretlyNotices():Array 
		{
			return [NoticeDefined.ON_ENTER_MAP, NoticeDefined.ON_QUIT_MAP, NoticeDefined.ON_USER_MOVE,NoticeDefined.ON_STAND_HERE];
		}
		
		//责任处理
		override public function dutyEvented(event:Evented):void 
		{
			switch(event.name)
			{
				case NoticeDefined.ON_ENTER_MAP:
					enterMap(event.data as EnterResult);
					break;
				case NoticeDefined.ON_QUIT_MAP:
					quitMap(event.data as QuitResult);
					break;
				case NoticeDefined.ON_USER_MOVE:
					WorldMap.gets().move(event.data.player as PlayerObj);
					break;
				case NoticeDefined.ON_STAND_HERE:
					WorldMap.gets().stop(event.data.player as PlayerObj);
					break;
			}
		}
		
		private function enterMap(data:EnterResult):void
		{
			if (data.self) {
				WorldMap.gets().showMap(data.mapId);
			}else {
				WorldMap.gets().createPlayer(data.player);
			}
		}
		
		private function quitMap(data:QuitResult):void
		{
			if (!_ismap) return;
			if (data.player.isSelf()) {
				WorldMap.gets().free();
			}else {
				WorldMap.gets().removeUser(data.player.uid);
			}
		}
		
		//ends
	}
}