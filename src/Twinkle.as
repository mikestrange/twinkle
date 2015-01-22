package 
{
	import com.greensock.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.utils.*;
	import game.consts.*;
	import game.datas.obj.PlayerObj;
	import game.logic.WorldKidnap;
	import game.ui.core.GpuCustom;
	import game.ui.core.ActionType;
	import game.ui.map.RoleSprite;
	import org.web.sdk.display.engine.*;
	import org.web.sdk.display.*;
	import org.web.sdk.*;
	import org.web.sdk.gpu.BufferImage;
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
	
	public class Twinkle extends KitSprite
	{
		private var _box:KitSprite;
		
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
			WorldKidnap.gets().start();
			//
			ServerSocket.create(new AssignedTransfer);	//socket建立
			PerfectLoader.gets().LOAD_MAX = 5;			//最大下载
			FpsMonitor.gets().show();					//内存查看
			//SoundManager.playUrl("bg.mp3");				
			StartLayer.gets().show();
			//------
			return;
			var url:String = "http://e.hiphotos.baidu.com/zhidao/pic/item/1b4c510fd9f9d72ab4b95ef0d42a2834359bbb7a.jpg";
			var butter:BufferImage = new BufferImage(url);
			this.addDisplay(butter)
		}
		
		//ends
	}
	
}
