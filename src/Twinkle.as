package 
{
	import com.greensock.*;
	import org.web.sdk.context.ResourceContext;
	import org.web.sdk.display.asset.KitBitmap;
	import org.web.sdk.display.asset.KitFactory;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.core.ActiveSprite;
	import org.web.sdk.display.bar.BaseButton;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.core.base.RayMovieClip;
	import org.web.sdk.display.utils.AlignType;
	//as3
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	//game
	import game.consts.*;
	import game.GameGlobal;
	import game.logic.WorldKidnap;
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
	import org.web.sdk.system.com.*;
	import org.web.sdk.system.core.*;
	import org.web.sdk.system.events.*;
	import org.web.sdk.system.*;
	import org.web.sdk.tool.*;
	import org.web.sdk.utils.*;
	
	[SWF(frameRate = "60", width = "800", height = "600")]
	
	public class Twinkle extends ActiveSprite
	{
		override protected function showEvent():void
		{
			//MenuTools.setMenu(this,null,MenuTools.createMenuItem("log",onLog))
			//启动模块
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//
			Security.allowDomain("*")
			Security.allowInsecureDomain("*")
			Security.loadPolicyFile("http://127.0.0.1/crossdomain.xml")
			//世界启动
			WorldKidnap.gets().initLayer(this);
			//最大下载
			PerfectLoader.gets().LOAD_MAX = 5;			
			//内存查看
			//FpsMonitor.gets().show();					
			//启动模块和网络连接
			WorldKidnap.gets().start();
			//加载配置
			FrameWork.downLoad("asset/config.xml", LoadEvent.TXT, complete);
			//test();
			//SoundManager.playUrl("bg.mp3");
			this.setLimit(stage.stageWidth, stage.stageHeight);
			
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
					FrameWork.downLoad(GameGlobal.getURL(url), LoadEvent.SWF, resComplete, names, FrameWork.currentContext);
				}
			}
			trace("res:", length);
		}
		
		private function resComplete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) return;
			//FrameWork.appDomain.share(e.url, e.getAppDomain());
			trace("--------res load over,start game---------")
			//登陆模块
			//LandSprite.gets().show();
			//test
			MouseDisplay.show();
			MouseDisplay.setDown(new RayDisplayer("MouseClick"));
			MouseDisplay.setRelease(new RayDisplayer("MouseNormal"))
			//addDisplay(new TestPanel);
		}
		//ends
	}
	
}
