package 
{
	import com.greensock.*;
	import game.ui.core.ActionType;
	import game.ui.core.RangeMotion;
	import game.ui.map.RoleSprite;
	import org.web.sdk.admin.AlertManager;
	import org.web.sdk.admin.WinManager;
	import org.web.sdk.display.asset.*;
	import org.web.sdk.display.core.*;
	import org.web.sdk.display.game.map.MapCamera;
	import org.web.sdk.display.game.map.MapDatum;
	import org.web.sdk.display.game.map.LandSprite;
	import org.web.sdk.display.game.map.MapPath;
	import org.web.sdk.display.mouse.MouseDisplay;
	import org.web.sdk.frame.core.ClientServer;
	import org.web.sdk.global.string;
	import org.web.sdk.global.tool.Ticker;
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
			//启动模块
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//
			AppWork.utilization(new Director(this), stage.stageWidth, stage.stageHeight);
			this.setLimit(stage.stageWidth, stage.stageHeight);		
			//加载配置
			var swfLoader:DownLoader = new DownLoader;
			swfLoader.eventHandler = function(event:LoadEvent):void
			{
				AppWork.appDomains.share(event.url,event.getDomain())
				if (swfLoader.empty) startGame();
			}
			
			//下载配置，这种下载，完成自己的责任就会被销毁，不必留在内存中 
			var loader:DownLoader = new DownLoader();
			loader.load("asset/config.xml");
			loader.eventHandler = function(event:LoadEvent):void
			{
				var xml:XML = new XML(event.data as String);
				var length:int = xml.res[0].ui.length();
				for (var i:int = 0; i < length; i++)
				{
					var url:String = xml.res[0].ui[i].@url;
					var names:String = xml.res[0].ui[i].@name;
					if (url && url != "") swfLoader.load(url, AppWork.context);
				}
			}
			loader.start();
			//SoundManager.playUrl("asset/bg.mp3");
		}
		
		private var action:RangeMotion;
		private var camera:MapCamera;
		
		private function startGame():void
		{
			trace("--------res load over,start game---------");
			//登陆模块
			MouseDisplay.show();
			MouseDisplay.setDown(RayDisplayer.quick("MouseClick"));
			MouseDisplay.setRelease(RayDisplayer.quick("MouseNormal"));
			
			action = new RangeMotion(0, ActionType.STAND, 4);
			action.doAction(ActionType.RUN, 4, 3);
			camera = new MapCamera;
			
			var loader:DownLoader = new DownLoader;
			loader.eventHandler = function(e:LoadEvent):void
			{
				camera.setMap(new LandSprite(MapDatum.create(new XML(e.data))));
				//Ticker.step(50, move, 0);
				addDisplay(camera.getView());
				camera.getView().addDisplay(action);
				camera.updateBuffer();
			}
			loader.load(MapPath.getMapConfig(3001));
			loader.start();
			stage.addEventListener(MouseEvent.CLICK, onClick);
			//
			//WinManager.show("test", new TestPanel);
			//AlertManager.gets().push(new TestTips);
			this.alpha = .1;
			AppWork.addStageListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void
		{
			camera.updateBuffer();
			trace( -camera.lookx, -camera.looky);
		}
		
		private function onClick(e:MouseEvent):void
		{
			var pos:Point = camera.getView().toLocal(stage.mouseX, stage.mouseY);
			
			action.moveTo(pos.x, pos.y);
			//camera.lookTo(pos.x, pos.y);
			TweenLite.killTweensOf(camera);
			TweenLite.to(camera, 1, { lookx:pos.x, looky:pos.y } );
			trace(pos);
		}
		//ends
	}
	
}
