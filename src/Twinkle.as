package 
{
	import com.greensock.*;
	import org.web.sdk.display.asset.*;
	import org.web.sdk.display.core.*;
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
	import org.web.sdk.inters.*;
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
			//MenuTools.setMenu(this,null,MenuTools.createMenuItem("log",onLog))
			//启动模块
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//
			Crystal.utilization(new Director(this), 0, 0);
			this.setLimit(stage.stageWidth, stage.stageHeight);
			//最大下载
			//内存查看
			FpsMonitor.gets().show();					
			//加载配置
			var swfLoader:DownLoader = new DownLoader;
			swfLoader.eventHandler = function(event:LoadEvent):void
			{
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
					if (url && url != "") swfLoader.load(url, Crystal.context);
				}
				swfLoader.start();
			}
			loader.start();
			//SoundManager.playUrl("asset/bg.mp3");
			//
		}
		
		private function onLog(e:Object):void
		{
			Log.save();
		}
		
		private function startGame():void
		{
			trace("--------res load over,start game---------")
			//登陆模块
			MouseDisplay.show();
			MouseDisplay.setDown(RayDisplayer.quick("MouseClick"));
			MouseDisplay.setRelease(RayDisplayer.quick("MouseNormal"));
			//
			Crystal.director.goto(new Ascene());
		}
		//ends
	}
	
}
