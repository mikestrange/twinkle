package game.mvc 
{
	import game.GameGlobal;
	import org.web.sdk.display.House;
	import flash.display.*;
	import flash.events.Event;
	import game.consts.CmdDefined;
	import game.consts.ModuleType;
	import game.consts.NoticeDefined;
	import game.mvc.cmd.GameManager;
	import game.socket.LogicSend;
	import game.mvc.room.MapController;
	import game.consts.LayerType;
	import org.web.sdk.display.ILayer;
	import org.web.sdk.FrameWork;
	import org.web.sdk.net.socket.handler.CmdManager;
	import org.web.sdk.system.*;
	import org.web.sdk.system.com.Invoker;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.tool.FpsMonitor;
	
	public class WorldKidnap extends Kidnap 
	{
		private static var _ins:WorldKidnap;
		
		public static function gets():WorldKidnap
		{
			if (null == _ins) _ins = new WorldKidnap;
			return _ins;
		}
		
		//初始化图层
		public function initLayer(root:DisplayObjectContainer, sceneWidth:int = 3000, sceneHeight:int = 2000):void
		{
			if (House.nativer.root) return;
			//框架启动
			//root.visible = false;
			FrameWork.utilization(root.stage, sceneWidth, sceneHeight, false, true, true);
			//图层初始化
			House.nativer.root = root;
			House.nativer.createLayer(LayerType.BACK_DROP, 1);
			House.nativer.createLayer(LayerType.MAP, 2);
			House.nativer.createLayer(LayerType.UI, 3);
			House.nativer.createLayer(LayerType.TIPS, 4);
			House.nativer.createLayer(LayerType.LOADING, 5);
			House.nativer.createLayer(LayerType.TOP, 6);
			//屏幕改变的时候
			FrameWork.stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function onResize(e:Event = null):void
		{
			FrameWork.followWin(House.nativer.root);
			FrameWork.graphicsViewArea(FpsMonitor.gets().graphics);
		}
		
		//添加到图层，不进行其他操作
		public static function addToLayer(dis:DisplayObject, layerName:String = LayerType.UI):void
		{
			House.nativer.addToLayer(dis, layerName);
		}
		
		//launch  初始化模块
		override protected function initialization():void 
		{
			super.initialization();
			//服务器回执注册
			GameManager.gets().register();
			//添加本地命令
			addInvoker();
			//添加模块
			addControllers();
		}
		
		private function addInvoker():void
		{
			var _invoker:Invoker = new Invoker(getMessage());
			_invoker.addOnlyCommand(NoticeDefined.SET_LOGIC, LogicSend);
			getMessage().addInvoker("world", _invoker);
		}
		
		private function addControllers():void
		{
			this.addController(new MapController);
		}
		
		override public function free():void 
		{
			super.free();
			getMessage().removeInvoker("world");
		}
		
		override public function getSecretlyNotices():Array 
		{
			return [NoticeDefined.ON_LOGIC];
		}
		
		override public function dutyEvented(event:Evented):void 
		{
			switch(event.name)
			{
				case NoticeDefined.ON_LOGIC:
					trace("成功登陆");
					if (GameGlobal.isDebug) sendMessage(NoticeDefined.ENTER_MAP);
				break;
			}
		}
		//ends
	}
}