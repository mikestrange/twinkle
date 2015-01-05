package game.mvc 
{
	import flash.display.*;
	import flash.events.Event;
	import game.consts.NoticeDefined;
	import game.mvc.room.MapController;
	import game.consts.LayerType;
	import org.web.sdk.display.core.house.*;
	import org.web.sdk.display.inters.ILayer;
	import org.web.sdk.FrameWork;
	import org.web.sdk.system.*;
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
			House.nativer.addLayer(new Layer(LayerType.BACK_DROP));
			House.nativer.addLayer(new Layer(LayerType.MAP));
			House.nativer.addLayer(new Layer(LayerType.UI));
			House.nativer.addLayer(new Layer(LayerType.TIPS));
			House.nativer.addLayer(new Layer(LayerType.LOADING, true));
			House.nativer.addLayer(new Layer(LayerType.TOP));
			//屏幕改变的时候
			FrameWork.stage.addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		private function onResize(e:Event = null):void
		{
			FrameWork.showRect(House.nativer.root, House.nativer.getLayer(LayerType.TOP).graphics);
		}
		
		//添加到图层，不进行其他操作
		public static function addToLayer(dis:DisplayObject, layerName:String = LayerType.UI, floor:int = -1):void
		{
			var layer:ILayer = House.nativer.getLayer(layerName);
			if (layer) layer.addChildDoName(dis, null, floor);
		}
		
		//launch  初始化模块
		override protected function initialization():void 
		{
			super.initialization();
			WorldModule.gets().register();
			//添加命令
			getMessage().addInvoker("world", new WorldInvoker);
			//添加模块
			addControllers();
		}
		
		private function addControllers():void
		{
			this.addController(new MapController);
		}
		
		override public function free():void 
		{
			super.free();
			if (!this.isLaunch()) {
				WorldModule.gets().destroy();
				getMessage().removeInvoker("world");
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