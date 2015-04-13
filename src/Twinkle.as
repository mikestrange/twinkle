package 
{
	import com.greensock.*;
	import game.ui.RangeMotion;
	import game.ui.type.ActionType;
	import org.web.sdk.admin.AlertManager;
	import org.web.sdk.admin.WinManager;
	import org.web.sdk.display.asset.*;
	import org.web.sdk.display.core.*;
	import org.web.sdk.display.core.com.Chooser;
	import org.web.sdk.display.core.com.interfaces.IElement;
	import org.web.sdk.display.core.com.interfaces.ITouch;
	import org.web.sdk.display.core.com.scroll.ScrollSprite;
	import org.web.sdk.display.core.com.test.TouchTest;
	import org.web.sdk.display.core.stock.BaseButton;
	import org.web.sdk.display.game.map.MapCamera;
	import org.web.sdk.display.game.map.MapDatum;
	import org.web.sdk.display.game.map.LandSprite;
	import org.web.sdk.display.game.map.MapPath;
	import org.web.sdk.display.mouse.MouseDisplay;
	import org.web.sdk.global.DateTimer;
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
			//启动模块
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//
			AppWork.utilization(new Director(this), 3000, 2000);
			AppWork.lookEms(true);
			this.setLimit(stage.stageWidth, stage.stageHeight);		
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
			//
			var downA:Function = function(...rest):void
			{
				
			}
			KeyManager.keyListener(Keyboard.A, "entera", downA);
			//return;
			action = new RangeMotion(0, ActionType.STAND, 4);
			action.doAction(ActionType.RUN, 4);
			camera = new MapCamera;
			
			var loader:DownLoader = new DownLoader;
			loader.completeHandler = function(e:LoadEvent):void
			{
				camera.setMap(new LandSprite(MapDatum.create(e.xml)));
				camera.getView().addDisplay(action);
				camera.updateBuffer();
				camera.getView().addEventListener(MouseEvent.CLICK, onClick);
				addDisplay(camera.getView(), 0);
			}
			loader.load(MapPath.getMapConfig(3003));
			loader.start();
			//WinManager.show("test", new TestPanel);
			//AlertManager.gets().push(new TestTips);
			//---
			setResize();
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
			TweenLite.to(action, .2, { x:pos.x, y:pos.y } );
			//action.moveTo(pos.x, pos.y);
			var time:int = getTimer();
			camera.lookTo(pos.x, pos.y);
			camera.updateBuffer();
			trace("地图渲染时间：", getTimer()-time);
		}
		
		//ends
	}
	
}
