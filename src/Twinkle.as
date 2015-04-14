package 
{
	import com.greensock.*;
	import org.web.sdk.admin.AlertManager;
	import org.web.sdk.admin.WinManager;
	import org.web.sdk.display.core.*;
	import org.web.sdk.display.core.com.Chooser;
	import org.web.sdk.display.core.com.interfaces.IElement;
	import org.web.sdk.display.core.com.interfaces.ITouch;
	import org.web.sdk.display.core.com.scroll.ScrollSprite;
	import org.web.sdk.display.core.com.test.TouchTest;
	import org.web.sdk.display.form.core.RayButton;
	import org.web.sdk.display.form.RayAnimation;
	import org.web.sdk.display.form.RayObject;
	import org.web.sdk.display.game.geom.FormatUtils;
	import org.web.sdk.display.game.map.MapCamera;
	import org.web.sdk.display.game.map.MapDatum;
	import org.web.sdk.display.game.map.LandSprite;
	import org.web.sdk.display.game.map.MapPath;
	import org.web.sdk.display.mouse.MouseDisplay;
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
		
		private var camera:MapCamera;
		private var action:RayAnimation;
		
		private function startGame():void
		{
			trace("--------res load over,start game---------");
			//
			for (var i:int = 0; i < 2000; i++ ) {
				action = RayAnimation.formatSenior("beaten");
				action.play(1, "run_2%t.png");
				action.setAlign("center");
				this.addDisplay(action);
				action.moveTo(maths.random(0, AppWork.stageWidth), maths.random(0, AppWork.stageHeight));
			}
			this.setRunning(true);
			//return;
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
		
		private var type:int;
		
		private function onClick(e:MouseEvent):void
		{
			//取鼠标点击的位置
			var pos:Point = camera.getView().toLocal(stage.mouseX, stage.mouseY);
			TweenLite.to(action, 2, { x:pos.x, y:pos.y,onComplete:stopMove } );
			var time:int = getTimer();
			camera.lookTo(pos.x, pos.y);
			camera.updateBuffer();
			type = FormatUtils.getIndexByAngle(maths.atanAngle(action.x, action.y, pos.x, pos.y));
			var chat:String = string.format("run_%t%t.png", type);
			//trace(chat)
			if (chat != action.getAction()) action.setAction(chat);
			//
			trace("地图渲染时间：", getTimer()-time);
		}
		
		private function stopMove():void
		{
			var chat:String = string.format("stand_%t%t.png", type);
			if (chat != action.getAction()) action.setAction(chat);
		}
		
		private var fast:Boolean = false;
		override protected function runEnter(e:Event = null):void 
		{
			var time:int = getTimer();
			if (this.numChildren < 2) return;
			var list:Array = [];
			var i:int = 0;
			var dis:DisplayObject;
			for (i = 0; i < this.numChildren; i++) {
				dis = this.getChildAt(i);
				dis.y = dis.y | 0;
				list[i] = dis;
			}
			list.sortOn("y", Array.NUMERIC);
			fast = !fast;
			if (fast) {
				for (i = 0; i < list.length/2; i++) {
					dis = list[i];
					if (this.getChildIndex(dis) == i) continue;
					this.setChildIndex(dis, i);
				}
			}else {
				for (i = list.length/2; i < list.length; i++) {
					dis = list[i];
					if (this.getChildIndex(dis) == i) continue;
					this.setChildIndex(dis, i);
				}
			}
			
			trace("渲染时间：", getTimer() - time);
		}
		//ends
	}
	
}
