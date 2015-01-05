package 
{
	import com.greensock.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.utils.*;
	import game.consts.NoticeDefined;
	import game.mvc.WorldKidnap;
	import game.consts.CmdDefined;
	import game.ui.map.WorldMap;
	import org.alg.map.*;
	import org.web.sdk.display.core.*;
	import org.web.sdk.display.core.house.*;
	import org.web.sdk.display.engine.*;
	import org.web.sdk.display.inters.*;
	import org.web.sdk.display.*;
	import org.web.sdk.*;
	import org.web.sdk.gpu.actions.*;
	import org.web.sdk.gpu.core.CreateTexture;
	import org.web.sdk.load.*;
	import org.web.sdk.log.*;
	import org.web.sdk.net.socket.base.*;
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
	
	public class Main extends BoneSprite
	{
		public function Main():void 
		{
			if (stage) showEvent();
			else addEventListener(Event.ADDED_TO_STAGE, showEvent);
		}
		
		override protected function showEvent(e:Object = null):void 
		{
			if (e) removeEventListener(Event.ADDED_TO_STAGE, showEvent);
			var time:int = getTimer();
			//启动模块
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			//世界启动
			WorldKidnap.gets().initLayer(this);
			WorldKidnap.gets().launch(null);
			//
			FpsMonitor.gets().show();
			//
			PerfectLoader.gets().LOAD_MAX = 5;
			//
			StartLayer.gets().show();
		}
		
		
		//ends
	}
	
}