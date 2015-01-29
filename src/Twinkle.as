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
	import org.web.sdk.inters.IDisplayObject;
	import org.web.sdk.load.*;
	import org.web.sdk.log.*;
	import org.web.sdk.net.amf.AMFRemoting;
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
			MenuTools.setMenu(this)
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
			//AMFRemoting.test();
			//test();
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
		
		private var arr:Vector.<Point>;
		private var step:Steper;
		[Embed(source = "../bin/back.gif")]
		private var MAP:Class;
		//
		private var item:IAcceptor;
		private var index:int = 0;
		
		private function test():void
		{
			step = new Steper(this);
			step.run();
			arr = new Vector.<Point>
			for (var i:int = 0; i < 300; i++) {
				arr.push(new Point(Maths.random(0, 500), Maths.random(0, 500)));
			}
			item = VRayMap.createByBitmapdata(new MAP().bitmapData);
			Bezier.drawLine(this.graphics, arr, false);
			this.addDisplay(item, 0, 0);
			//
			var cool:CoolTime = new CoolTime(100, 100);
			cool.x = 100;
			cool.y = 100;
			this.addChild(cool)
			cool.setup(10, 5);
		}
		
		override public function render():void 
		{
			if (index >= arr.length) return;
			
			if (renderMove(item, arr, index)) index++;
			
			this.graphics.lineTo(item.x, item.y);
		}
		
		//是否
		public static function renderMove(dis:IDisplayObject, vector:Vector.<Point>, index:int = 0, speed:int = 100):Boolean
		{
			if (index < 0 || index >= vector.length) return false;
			var angle:Number = Maths.atanAngle(dis.x, dis.y, vector[index].x, vector[index].y);	//计算两点之间的角度
			var mpo:Point = Maths.resultant(angle, speed);										//计算增量
			dis.x -= mpo.x;
			dis.y -= mpo.y;
			//两点之间的长度
			if (Maths.distance(dis.x, dis.y, vector[index].x, vector[index].y) <= speed) {
				dis.moveTo(vector[index].x, vector[index].y);
				return true;
			}
			return false;
		}
		//ends
	}
	
}
