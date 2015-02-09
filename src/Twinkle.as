package 
{
	import com.greensock.*;
	import org.web.sdk.display.asset.SingleTexture;
	import org.web.sdk.display.ray.RayDisplayer;
	import org.web.sdk.display.ray.RayMovieClip;
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
	import org.web.sdk.system.key.*;
	import org.web.sdk.system.events.*;
	import org.web.sdk.system.key.*;
	import org.web.sdk.system.*;
	import org.web.sdk.tool.*;
	import org.web.sdk.utils.*;
	
	[SWF(frameRate = "60", width = "500", height = "400")]
	
	public class Twinkle extends RawSprite
	{
		public function Twinkle():void 
		{
			if (stage) showEvent();
			else addEventListener(Event.ADDED_TO_STAGE, showEvent);
		}
		
		override public function showEvent(event:Event = null):void 
		{
			super.showEvent(event);
			if (event) removeEventListener(Event.ADDED_TO_STAGE, showEvent);
			MenuTools.setMenu(this,null,MenuTools.createMenuItem("log",onLog))
			//启动模块
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			//世界启动
			WorldKidnap.gets().initLayer(this);
			//最大下载
			PerfectLoader.gets().LOAD_MAX = 5;			
			//内存查看
			FpsMonitor.gets().show();					
			//启动模块和网络连接
			WorldKidnap.gets().start();
			//加载配置
			FrameWork.downLoad("config.xml", LoadEvent.TXT, complete);
			//test();
			//SoundManager.playUrl("bg.mp3");
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
				if (url && url != "") {
					FrameWork.downLoad(GameGlobal.getURL(url), LoadEvent.SWF, resComplete, names, FrameWork.currentContext);
				}
			}
			trace("res:", length);
		}
		
		private function resComplete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) return;
			FrameWork.app.share(e.url, e.target as Loader);
			if (!PerfectLoader.gets().isLoad()) trace("--------res load over,start game---------")
			//登陆模块
			//LandSprite.gets().show();
		}
		//ends
	}
	
}
