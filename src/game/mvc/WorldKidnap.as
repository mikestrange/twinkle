package game.mvc 
{
	import flash.display.*;
	import flash.events.Event;
	import game.consts.CmdDefined;
	import game.consts.ModuleType;
	import game.consts.NoticeDefined;
	import game.mvc.net.beat.HeartBeat;
	import game.mvc.net.request.LogicRequest;
	import game.mvc.net.result.LogicResult;
	import game.mvc.room.MapController;
	import game.consts.LayerType;
	import org.web.sdk.display.core.house.*;
	import org.web.sdk.display.core.house.ILayer;
	import org.web.sdk.FrameWork;
	import org.web.sdk.net.socket.SocketModule;
	import org.web.sdk.system.*;
	import org.web.sdk.system.com.Invoker;
	import org.web.sdk.system.events.Evented;
	
	public class WorldKidnap extends Kidnap 
	{
		private static var _ins:WorldKidnap;
		
		public static function gets():WorldKidnap
		{
			if (null == _ins) _ins = new WorldKidnap;
			return _ins;
		}
		
		//初始化图层
		public function initLayer(root:DisplayObjectContainer, sceneWidth:int = 4000, sceneHeight:int = 3000):void
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
			//FrameWork.showRect(House.nativer.root, House.nativer.getLayer(LayerType.TOP).graphics);
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
			//
			addModule();
			addInvoker();
			//添加模块
			addControllers();
		}
		
		private var _invoker:Invoker;
		private function addInvoker():void
		{
			_invoker = new Invoker;
			_invoker.register(getMessage());
			_invoker.addOnlyCommand(NoticeDefined.SET_LOGIC, LogicRequest);
		}
		
		private var _moduble:SocketModule;
		private function addModule():void
		{
			_moduble = new SocketModule(ModuleType.WORLD);
			_moduble.addRespond(CmdDefined.LOGIC_GAME, LogicResult);
			_moduble.addRespond(CmdDefined.HEART_BEAT, HeartBeat);
		}
		
		private function addControllers():void
		{
			this.addController(new MapController);
		}
		
		override public function free():void 
		{
			super.free();
			if (!this.isLaunch()) {
				_invoker.quit();
				_moduble.destroy();
			}
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
					break;
				
			}
		}
		
		//ends
	}
}