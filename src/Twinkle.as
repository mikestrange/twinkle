package 
{
	import com.greensock.*;
	import org.web.sdk.admin.AlertManager;
	import org.web.sdk.admin.PopupManager;
	import org.web.sdk.display.base.AppDirector;
	import org.web.sdk.display.base.BaseScene;
	import org.web.sdk.display.core.*;
	import org.web.sdk.display.core.com.Chooser;
	import org.web.sdk.display.core.com.interfaces.IElement;
	import org.web.sdk.display.core.com.interfaces.ITouch;
	import org.web.sdk.display.core.com.scroll.ScrollSprite;
	import org.web.sdk.display.core.com.test.TouchTest;
	import org.web.sdk.display.game.ssh.LoadEffect;
	import org.web.sdk.display.paddy.base.RayButton;
	import org.web.sdk.display.paddy.RayAnimation;
	import org.web.sdk.display.paddy.RayObject;
	import org.web.sdk.display.game.geom.TaxReckon;
	import org.web.sdk.display.game.map.MapCamera;
	import org.web.sdk.display.game.map.MapDatum;
	import org.web.sdk.display.game.map.LandSprite;
	import org.web.sdk.display.game.map.MapPath;
	import org.web.sdk.display.game.role.RolePart;
	import org.web.sdk.display.mouse.MouseDisplay;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.display.utils.SortSprite;
	import org.web.sdk.global.DateTimer;
	import org.web.sdk.global.maths;
	import org.web.sdk.global.string;
	import org.web.sdk.global.tool.Ticker;
	import org.web.sdk.keyset.KeyManager;
	//as3
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	//org
	import org.web.sdk.display.engine.*;
	import org.web.sdk.display.*;
	import org.web.sdk.*;
	import org.web.sdk.interfaces.*;
	import org.web.sdk.load.*;
	import org.web.sdk.log.*;
	import org.web.sdk.net.socket.*;
	import org.web.sdk.sound.core.*;
	import org.web.sdk.sound.*;
	import org.web.sdk.tool.*;
	import org.web.sdk.utils.*;
	
	[SWF(frameRate = "60", width = "800", height = "600")]
	
	public class Twinkle extends BaseSprite
	{
		override protected function showEvent():void
		{
			Log.allow("*")
			//启动模块
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//
			AppWork.utilization(this.stage, 3000, 2000);
			//AppWork.lookEms(true);
			AppDirector.gets().setContainer(this);
			this.setSize(stage.stageWidth, stage.stageHeight);		
			//加载配置
			var swfLoader:DownLoader = new DownLoader;
			swfLoader.completeHandler = function(event:LoadEvent):void
			{
				event.shareDomain();
				if (swfLoader.empty) startGame();
			}
			
			//下载配置，这种下载，完成自己的责任就会被销毁，不必留在内存中 
			var loader:DownLoader = new DownLoader();
			//如果要下载其他域的资源，请补全路径
			loader.load("asset/config.xml");
			loader.completeHandler = function(event:LoadEvent):void
			{
				var xml:XML = event.xml;
				var length:int = xml.res[0].ui.length();
				for (var i:int = 0; i < length; i++)
				{
					var url:String = xml.res[0].ui[i].@url;
					var names:String = xml.res[0].ui[i].@name;
					if (url && url != "") swfLoader.load(url, AppWork.context, "" + DateTimer.getDateTime());
				}
			}
			loader.start();
			
			//测试场景
			AppDirector.gets().getSceneHandler = function(sceneName:String):IBaseScene
			{
				return new BaseScene;	
			}
			//
			//SoundManager.playUrl("asset/bg.mp3");
		}
		
		private var rays:RayObject;
		private var camera:MapCamera;
		private var action:RolePart;
		
		private function startGame():void
		{
			trace("--------res load over,start game---------");
			//return;
			camera = new MapCamera;
			PopupManager.showRegister(new TestPanel);
			//
			function downEnter(...rest):void
			{
				
			}
			KeyManager.keyListener(Keyboard.SPACE, "jo", downEnter);
			var loader:DownLoader = new DownLoader(mapComplete);
			loader.load(MapPath.getMapConfig(3002));
			loader.start();
			//---
			setResize();
		}
		
		private function mapComplete(event:LoadEvent):void
		{
			camera.setMap(new LandSprite(MapDatum.create(event.xml)));
			//
			for (var i:int = 0; i < 200; i++ ) {
				action = new RolePart("beaten");
				action.frameRate = 100
				action.setState("stand", 3);
				camera.getView().addDisplay(action);
				action.moveTo(maths.random(0, 1000 + AppWork.stageWidth), maths.random(0, 1000 + AppWork.stageHeight));
			}
			
			camera.updateBuffer();
			camera.getView().addEventListener(MouseEvent.CLICK, onClick);
			addDisplay(camera.getView(), 0);
			//
			setRunning(true);
		}
		
		override protected function onResize(e:Event = null):void 
		{
			camera.lookTo(action.x, action.y);
			camera.updateBuffer();
		}
		
		private function onClick(e:MouseEvent):void
		{
			//取鼠标点击的位置
			var pos:Point = camera.getView().toLocal(stage.mouseX, stage.mouseY);
			TweenLite.killTweensOf(action);
			TweenLite.to(action, 2, { x:pos.x, y:pos.y,onComplete:stopMove } );
			camera.lookTo(pos.x, pos.y);
			camera.updateBuffer();
			//跑动
			action.setState("run", TaxReckon.getIndexByAngle(maths.atanAngle(action.x, action.y, pos.x, pos.y)));
			//
			var eff:LoadEffect = new LoadEffect("952700");
			eff.moveTo(pos.x, pos.y);
			camera.getView().addDisplay(eff);
		}
		
		private function stopMove():void
		{
			action.setState("stand", action.point);
		}
		
		private var currentTime:int;
		
		override protected function runEnter(event:Event = null):void 
		{
			if (getTimer() - currentTime < 200) return;
			currentTime = getTimer();
			if (camera) SortSprite.sort(camera.getView());
			
		}
		//ends
	}
	
}
