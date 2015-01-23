package 
{
	import com.greensock.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.ui.*;
	import flash.utils.*;
	import game.consts.*;
	import game.GameGlobal;
	import game.logic.WorldKidnap;
	import org.web.sdk.display.engine.*;
	import org.web.sdk.display.*;
	import org.web.sdk.*;
	import org.web.sdk.gpu.*;
	import org.web.sdk.gpu.texture.BaseTexture;
	import org.web.sdk.inters.IAcceptor;
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
			//启动模块
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//世界启动
			WorldKidnap.gets().initLayer(this);
			//最大下载
			PerfectLoader.gets().LOAD_MAX = 5;			
			//内存查看
			FpsMonitor.gets().show();					
			//启动模块和网络连接
			WorldKidnap.gets().start();
			//登陆模块
			//LogicLayer.gets().show();
			//加载配置
			FrameWork.downLoad("config.xml", LoadEvent.TXT, complete);
			//
			test();
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
			if (!PerfectLoader.gets().isLoad()) {
				trace("res load over,start game")
			}
		}
		
		private var fs:Number=0;
		private var ips:IAcceptor;
		private var arr:Vector.<Point>
		
		private function test():void
		{
			ips = VRayMap.createBySize(50, 50, 0xff0000);
			this.addDisplay(ips);
			Clock.step(100, moves, 0);
			//
			
			arr = new Vector.<Point>;
			arr[0] = new Point(100,146)
			arr[1] = new Point(300,0)	//中间点
			arr[2] = new Point(500, 146)
			Bezier.drawLine(this.graphics, arr);
		}
		
		private function moves():void
		{
			var p:Point = Bezier.dot(fs, arr);
			ips.moveTo(p.x, p.y);
			fs += .01;
		}
		
		
		//ends
	}
	
}
