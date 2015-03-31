package 
{
	import com.greensock.*;
	import org.web.sdk.display.asset.*;
	import org.web.sdk.display.core.*;
	import org.web.sdk.frame.core.ClientServer;
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
			//最大下载
			Crystal.setLoadMaxLength(5)
			//内存查看
			//FpsMonitor.gets().show();					
			//启动模块和网络连接
			//加载配置
			Crystal.downLoad("asset/config.xml",complete);
			//test();
			//SoundManager.playUrl("bg.mp3");
			this.setLimit(stage.stageWidth, stage.stageHeight);
			//
			var client:ClientServer = new ClientServer(null);
			client.start();
		}
		
		private function onLog(e:Object):void
		{
			Log.save();
		}
		
		private function complete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) return;
			var xml:XML = new XML(e.target as String);
			var length:int = xml.res[0].ui.length();
			for (var i:int = 0; i < length; i++)
			{
				var url:String = xml.res[0].ui[i].@url;
				var names:String = xml.res[0].ui[i].@name;
				var main:Boolean = parseInt(xml.res[0].ui[i].@main) == 1;
				if (url && url != "") {
					Crystal.downLoad(url, resComplete, i == length - 1, Crystal.context);
				}
			}
			trace("res:", length);
		}
		
		private function resComplete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) return;
			//Ramt.appDomain.share(e.url, e.getContext());
			if (e.data == false) return;
			trace("--------res load over,start game---------")
			//登陆模块
			//test
			MouseDisplay.show();
			MouseDisplay.setDown(RayDisplayer.quick("MouseClick"));
			MouseDisplay.setRelease(RayDisplayer.quick("MouseNormal"));
			//
			Crystal.director.goto(new Ascene());
		}
		//ends
	}
	
}
