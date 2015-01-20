package 
{
	import party.greensock.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.System;
	import flash.ui.*;
	import flash.utils.*;
	import game.consts.LayerType;
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import game.mvc.WorldKidnap;
	import game.consts.CmdDefined;
	import game.ui.core.GpuCustom;
	import game.ui.map.WorldMap;
	import game.ui.core.ActionType;
	import game.ui.map.RoleSprite;
	import game.ui.map.RoleSprite;
	import org.alg.map.*;
	import org.web.sdk.display.engine.*;
	import org.web.sdk.display.*;
	import org.web.sdk.*;
	import org.web.sdk.gpu.BufferImage;
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
	import org.web.sdk.utils.list.HashList;
	import org.web.sdk.utils.list.ListNode;
	
	
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
			ServerSocket.create(new AssignedTransfer)
			PerfectLoader.gets().LOAD_MAX = 5;
			FpsMonitor.gets().show();
			SoundManager.playUrl("bg.mp3");
			StartLayer.gets().show();
			SocketClock.start();
		}
		
		//ends
	}
	
}


/*
 * var i:int = 0;
			var j:int = 0;
			var leng:int = 10000;
			var seachleng:int = 10000;
			
			var arr:Vector.<Number> = new Vector.<Number>;
			var time:int = getTimer();
			for (i = 0; i < leng; i++) {
				arr.push(i);
			}
			trace("array push time:", getTimer() - time);
			time = getTimer();
			for (j = 0; j < seachleng; j++) {
				var index:int = arr.indexOf(5000);
			}
			trace("array seach time:", getTimer() - time);
			
			var hash:HashList = new HashList;
			time = getTimer();
			for (i = 0; i < leng; i++) {
				hash.push(i + "", i);
			}
			trace("list push time:", getTimer() - time);
			time = getTimer();
			for (j = 0; j < seachleng; j++) {
				hash.getTarget("1000")
			}
			trace("list seach time:", getTimer() - time);
 * */