package org.web.sdk.tool 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.*;
	import org.web.sdk.FrameWork;

	//一个非常好的计时器
	public class Clock
	{
		private static const _KEY_:String = "whoisyourdaddy";
		private static var isStep:Boolean = false;
		private var clockList:Array;
		private const ZERO:int = 0;
		
		public function Clock(key:String = null) 
		{
			if (key != _KEY_) throw Error("不能自己擅自使用此类");
			clockList = new Array;
		}
		
		//添加一个监听的事务
		public function step(fps:Number, call:Function, times:uint = 0, args:Array = null):void
		{
			if (!isStep) {
				isStep = true;
				FrameWork.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
			clockList.push(new ClockData(fps, call, times,args));
		}
		
		private function onEnterFrame(e:Event):void
		{
			var data:ClockData;
			for (var i:int = 0; i < clockList.length; i++)
			{
				data = clockList[i];
				if (data.called == null) {
					clockList.splice(i, 1);
					continue;
				}
				if (getTimer() - data.gettimer >= data.fps) {
					data.gettimer = getTimer(); //不要等他渲染完成
					if (data.times == ZERO) {
						data.called.apply(null, data.args);
					}else {
						data.called.apply(null, data.args);
						if (--data.times <= ZERO) {
							//data.called = null;
							clockList.splice(i, 1);
							continue;
						}
					}
				}
			}
			if (isEmpty()) stop();
		}
		
		//没有真正的删除
		public function kill(call:Function, back:Boolean = false):void
		{
			var data:ClockData;
			var fun:Function;
			for (var i:int = 0; i < clockList.length; i++)
			{
				data = clockList[i];
				if (data.called == call) {
					fun = data.called;
					data.called = null;
					if (back) fun.apply(null, data.args);
				}
			}
		}
		
		private function stop():void
		{
			if (isStep) {
				isStep = false;
				FrameWork.stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		public function isEmpty():Boolean
		{
			return clockList.length == ZERO;	
		}
		
		public function clear():void
		{
			stop();
			if(clockList.length) clockList = [];
		}
		
		//一个全局定时器
		private static var clocks:Clock;
		
		//添加参数 [默认无限次]
		public static function step(delay:Number, called:Function, times:uint = 1, ...args):void
		{
			if (null == clocks) clocks = new Clock(Clock._KEY_);
			clocks.step(delay, called, times, args);
		}
		
		public static function kill(call:Function, back:Boolean = false):void
		{
			if (clocks) clocks.kill(call, back);
		}
		
		//ends
	}
}

import flash.utils.getTimer;

class ClockData {
	
	public var gettimer:Number;			//当前时间
	public var times:uint = 1; 			//0无限次，每调一次函数算一次 frame*time
	public var fps:Number;				//帧
	public var called:Function;			//每过delay就会调用一次
	public var args:Array;				//参数
	
	public function ClockData(fps:Number, call:Function, times:uint = 1, args:Array =null)
	{
		gettimer = getTimer();
		this.fps = fps;
		this.called = call;
		this.times = times;
		this.args = args;
	}
	//ends
}

