package org.web.sdk.global.tool 
{
	import flash.utils.*;
	import org.web.sdk.AppWork;
	/*
	 * 一个非常好的计时器
	 * FrameWork.stage就是stage
	 * */
	public class Ticker
	{
		private static const _KEY_:String = "whoisyourdaddy";
		//
		public static const ONCE:int = 1;
		private static const ZERO:int = 0;
		private var _isstep:Boolean = false;
		private var _stepList:Vector.<TickerInfo>;
		
		public function Ticker(key:String = null) 
		{
			if (key != _KEY_) throw Error("不能自己擅自使用此类");
		}
		
		//添加一个监听的事务
		public function registerTimer(interval:Number, completeHandler:Function, count:uint, parameters:Array):void
		{
			if (!_isstep) {
				_isstep = true;
				AppWork.addStageListener("enterFrame", runEvent);
				trace("#计时器激活");
			}
			if (_stepList == null) _stepList = new Vector.<TickerInfo>;
			_stepList.push(new TickerInfo(interval, completeHandler, count, getTimer(), parameters));
		}
		
		private function runEvent(event:Object):void
		{
			var data:TickerInfo;
			var currentTime:int = getTimer();
			var index:int = 0;
			//注册先后执行
			while (index < _stepList.length) {
				data = _stepList[index];
				if (!data.isLive) {
					_stepList.splice(index, 1);
					continue;
				}else {
					if (currentTime - data.lastTick >= data.interval)
					{
						data.lastTick = currentTime;
						if (data.repeatCount == ZERO) {
							data.execute();
						}else {
							if (--data.repeatCount <= ZERO) _stepList.splice(index, 1);
							data.execute();
							if (data.repeatCount <= ZERO) continue;
						}
					}
				}
				index++;
			}
			if (isEmpty()) clearAll();
		}
		
		//不会删除，监听同一函数的可以全部删除
		public function killTimer(complete:Function, all:Boolean = false):void
		{
			if (null == _stepList) return;
			var data:TickerInfo;
			for (var i:int = 0; i < _stepList.length; i++)
			{
				data = _stepList[i];
				if (data.isLive && data.completeHandler == complete)
				{
					data.free();
					if (!all) break;
				}
			}
		}
		
		public function isEmpty():Boolean
		{
			if (null == _stepList) return true;
			return _stepList.length == ZERO;	
		}
		
		//清理并且停止
		public function clearAll():void
		{
			if (_isstep) {
				_isstep = false;
				AppWork.removeStageListener("enterFrame", runEvent);
				trace("#计时器停止");
			}
			if (_stepList) {
				while (_stepList.length)
				{
					_stepList.shift().free();
				}
				_stepList = null;
			}
		}
		
		//一个全局定时器
		private static var _ticker:Ticker;
		
		//添加参数 [默认无限次]
		public static function step(interval:Number, completeHandler:Function, count:uint = 1, ...parameters):void
		{
			if (null == _ticker) _ticker = new Ticker(Ticker._KEY_);
			_ticker.registerTimer(interval, completeHandler, count, parameters);
		}
		
		public static function kill(complete:Function, always:Boolean = false):void
		{
			if (_ticker) {
				_ticker.killTimer(complete, always);
			}
		}
		
		public static function getTicker():Ticker
		{
			if (null == _ticker) _ticker = new Ticker(Ticker._KEY_);
			return _ticker;
		}
		//ends
	}
}

//------------------------------------TickerInfo---------------------------
class TickerInfo
{
	public var lastTick:Number;					//当前时间
	public var repeatCount:uint; 				//0无限次，每调一次函数算一次 frame*time
	public var interval:Number;					//帧
	public var completeHandler:Function;		//每过delay就会调用一次
	public var parameters:Array;				//参数
	public var isLive:Boolean;					//是否存货
	
	public function TickerInfo(interval:Number, completeHandler:Function, count:uint = 1, lasttime:int = 0, parameters:Array = null)
	{
		this.interval = interval;
		this.completeHandler = completeHandler;
		this.repeatCount = count;
		this.parameters = parameters;
		this.isLive = completeHandler is Function;
		this.lastTick = lasttime;
	}
	
	public function execute():void
	{
		if (isLive) {
			completeHandler.apply(null, parameters);
		}
	}
	
	public function free():void
	{
		this.isLive = false;
		this.completeHandler = null;
		this.parameters = null;
	}
	//ends
}
//------------------------------TickerInfo-------------------------------
