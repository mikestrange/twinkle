package org.web.sdk.tool 
{
	import flash.utils.*;
	import org.web.sdk.Ramt;
	/*
	 * 一个非常好的计时器
	 * FrameWork.stage就是stage
	 * */
	public class Clock
	{
		private static const _KEY_:String = "whoisyourdaddy";
		//
		private  var isstep:Boolean = false;
		private var clockList:Vector.<ClockData>;
		private const ZERO:int = 0;
		
		public function Clock(key:String = null) 
		{
			if (key != _KEY_) throw Error("不能自己擅自使用此类");
		}
		
		//添加一个监听的事务
		public function step(interval:Number, call:Function, times:uint = 0, args:Array = null):void
		{
			if (!isstep) {
				isstep = true;
				clockList = new Vector.<ClockData>;
				Ramt.addStageListener("enterFrame", runEvent);
			}
			clockList.push(new ClockData(interval, call, times,args));
		}
		
		private function runEvent(e:Object):void
		{
			var data:ClockData;
			for (var i:int = clockList.length - 1; i >= 0; i--)
			{
				data = clockList[i];
				if (!data.live) {
					clockList.splice(i, 1);
					continue;
				}
				if (getTimer() - data.gettimer >= data.interval) {
					data.gettimer = getTimer(); //不要等他渲染完成
					if (data.times == ZERO) {
						data.execute();
					}else {
						if (--data.times <= ZERO) clockList.splice(i, 1);
						data.execute();
					}
				}
			}
			if (isempty()) stop();
		}
		
		//不会删除
		public function kill(call:Function, value:Boolean = false, all:Boolean = true):void
		{
			var data:ClockData;
			var fun:Function;
			for (var i:int = 0; i < clockList.length; i++)
			{
				data = clockList[i];
				if (data.live && data.called == call) {
					fun = data.called;
					data.free();
					if (value) fun.apply(null, data.args);
					if (!all) break;
				}
			}
		}
		
		private function stop():void
		{
			if (isstep) {
				isstep = false;
				Ramt.removeStageListener("enterFrame", runEvent);
			}
		}
		
		public function isempty():Boolean
		{
			return clockList.length == ZERO;	
		}
		
		public function clear():void
		{
			stop();
			while (clockList.length) {
				clockList.shift().free();
			}
		}
		
		//一个全局定时器
		private static var clocker:Clock;
		
		//添加参数 [默认无限次]
		public static function step(delay:Number, called:Function, times:uint = 1, ...args):void
		{
			if (null == clocker) clocker = new Clock(Clock._KEY_);
			clocker.step(delay, called, times, args);
		}
		
		public static function kill(call:Function, value:Boolean = false):void
		{
			if (clocker) clocker.kill(call, value);
		}
		
		public static function get clock():Clock
		{
			if (null == clocker) clocker = new Clock(Clock._KEY_);
			return clocker;
		}
		//ends
	}
}

import flash.utils.getTimer;

class ClockData {
	
	public var gettimer:Number;			//当前时间
	public var times:uint = 1; 			//0无限次，每调一次函数算一次 frame*time
	public var interval:Number;				//帧
	public var called:Function;			//每过delay就会调用一次
	public var args:Array;				//参数
	public var live:Boolean;
	
	public function ClockData(interval:Number, call:Function, times:uint = 1, args:Array =null)
	{
		this.interval = interval;
		this.called = call;
		this.times = times;
		this.args = args;
		this.live = call is Function;
		gettimer = getTimer();
	}
	
	public function execute():void
	{
		if (live) called.apply(null, args);
	}
	
	public function free():void
	{
		live = false;
	}
	//ends
}

