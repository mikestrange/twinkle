package org.web.sdk 
{
	import flash.system.*;
	import flash.utils.*;
	import flash.display.*;
	import flash.events.*;
	import org.web.sdk.context.*;
	import org.web.sdk.display.asset.KitBitmap;
	import org.web.sdk.display.engine.*;
	import org.web.sdk.display.utils.DrawUtils;
	import org.web.sdk.keyset.*;
	import org.web.sdk.load.loads.*;
	import org.web.sdk.log.*;
	import org.web.sdk.pool.*;
	import org.web.sdk.load.*;
	import org.web.sdk.tool.*;

	public class FrameWork 
	{
		//可以利用他来屏蔽鼠标右键
		public static const RIGHT_MOUSE_DOWN:String = "rightMouseDown";
		//
		private static var $stage:Stage;
		private static var $system:SystemScope;
		//舞台
		public static function get stage():Stage
		{
			return $stage;
		}
		
		public static function addStageListener(type:String, called:Function):void
		{
			$stage.addEventListener(type, called);
		}
		
		public static function removeStageListener(type:String, called:Function):void
		{
			$stage.removeEventListener(type, called);
		}
		
		//启动  是否启动成功  初始化窗口
		public static function utilization(stage:Stage, width:Number = 0, height:Number = 0, sleep:Boolean = false, 
		engine:Boolean = true, keyset:Boolean = true):void
		{
			if (null == FrameWork.$stage) $stage = stage;
			if (null == $system) $system = new SystemScope(width, height);
			setKeyboard(keyset);
			setEngine(engine);
			setSleep(sleep);
		}
		
		//是否允许休眠
		public static function setSleep(value:Boolean):void
		{
			Sleep.canSleep = value;
		}
		
		//是否启动引擎
		public static function setEngine(value:Boolean):void
		{
			if (value) AtomicEngine.open();
			else AtomicEngine.close();
		}
		
		//是否启用键盘
		public static function setKeyboard(value:Boolean):void
		{
			KeyManager.gets(value);
			if (value) Log.log().debug('#启动键盘');
			else Log.log().debug('#关闭按键支持')
		}
		
		public static function get winWidth():Number 
		{
			return $system.width;
		}
		
		public static function get winHeight():Number 
		{
			return $system.height;
		}
		
		public static function get leftx():Number
		{
			return $system.x;
		}
		
		public static function get lefty():Number
		{
			return $system.y;
		}
		
		public static function get stageWidth():Number
		{
			return stage.stageWidth;
		}
		
		public static function get stageHeight():Number
		{
			return stage.stageHeight;
		}
		
		public static function setSize(w:Number, h:Number):void
		{
			$system.setSize(w, h);	
		}
		
		public static function followWin(root:DisplayObject, offsetx:Number = 0, offsety:Number = 0):void
		{
			if (root) {
				root.x = $system.x + offsetx;
				root.y = $system.y + offsety;
			}
		}
		
		//调整区域 这个东西的位置必须在 0 0
		public static function graphicsViewArea(graphics:Graphics, color:uint= 0, alpha:Number = .5):void
		{
			if (graphics) {
				//绘制主屏幕
				graphics.clear();
				graphics.beginFill(color, alpha);
				graphics.lineStyle(1, 0, 0);
				graphics.moveTo(0, 0);
				graphics.lineTo(stageWidth, 0);
				graphics.lineTo(stageWidth, stageHeight);
				graphics.lineTo(0, stageHeight);
				graphics.lineTo(0, 0);
				graphics.moveTo($system.x, $system.y);
				graphics.lineTo($system.width + $system.x, $system.y);
				graphics.lineTo($system.width + $system.x, $system.height + $system.y);
				graphics.lineTo($system.x, $system.height + $system.y);
				graphics.lineTo($system.x, $system.y);
				/*
				graphics.beginFill(0,.5);
				graphics.drawRect(0, 0, $system.width, $system.height);
				graphics.endFill();
				*/
			}
		}
		
		//对象管理池
		public static function getpool(fileName:String):Pools
		{
			return Pools.create(fileName);
		}
		
		//当前域
		public static function get currentContext():LoaderContext
		{
			return new LoaderContext(false, ApplicationDomain.currentDomain);
		}
		
		//所有程序域管理
		public static const appDomain:ContextManager = ContextManager.create();
		
		//唯一下载器
		public static const perfectLoader:PerfectLoader = PerfectLoader.gets();
		
		//下载资源
		public static function downLoad(url:String, type:int, complete:Function, data:Object = null, context:* = undefined, vital:Boolean = false):void
		{
			perfectLoader.addWait(url, type, context, vital).addRespond(complete, data);
			perfectLoader.start();
		}
		
		//两种索取素材的方法------------这种非RSL共享时候的  可能是BitmapData，所以是*
		public static function getAsset(className:String, url:String = null):Object
		{
			return appDomain.getAsset(className, url);
		}
		
		
		//ends
	}

}