package org.web.sdk.tool 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.utils.Dictionary;
	import flash.utils.*;
	import flash.utils.setTimeout;
	/*这里是一个控制影片播放的工具*/
	public class TweenMovie 
	{
		public static const _FPS_:int = 30;
		public static var _MOVIE_FPS_:Number = 30;
		//
		protected var startFrame:int = 1;			//开始帧
		protected var playNum:int = 1;        	 	//播放次数  <=0为永久
		protected var delay:Number = 30;       		//延迟毫秒
		protected var intervalTime:Number = 30;		//间隔时间
		protected var isWeak:Boolean = true;		//直接删除
		//
		protected var onComplete:Function;  		//在停止动画或者移除动画的时候是否回调
		protected var startCall:Function;			//开始播放的时候调用
		protected var parameter:Array;
		//
		private var _frameFunKey:Dictionary;		//帧监听	
		private var _movie:MovieClip;				//源对象
		private var _isPlay:Boolean = false;		//是否播放
		private var _setTime:Number = -1;				//延迟
		private var _startTime:Number = 0;
		
		public function TweenMovie(target:MovieClip, data:Object, parameter:Array = null) 
		{
			initialize(data); //初始化参数
			//
			_frameFunKey = new Dictionary;
			_movie = target;
			_movie.gotoAndStop(startFrame);
			this.parameter = parameter;
			//添加
			TweenMovie.tweenForListener(_movie, this);
			//小于20直接播放
			delay < 20 ? played() : _setTime = setTimeout(played, delay);
		}
	
		protected function initialize(data:Object):void
		{
			if (data == null) {
				intervalTime = _MOVIE_FPS_;
				return;
			}
			intervalTime 	= 	data["interval"] || _MOVIE_FPS_;	
			startFrame		= 	data["frame"] || 1;	
			playNum 		= 	data["times"] || 1;
			delay 			= 	data["delay"] || 30;   	 
			startCall 		= 	data["start"] || null;
			isWeak			= 	data["weak"] || true;
			onComplete 		= 	data["onComplete"] || null; 
		}
		
		private function played():void
		{
			_startTime = getTimer();
			_isPlay = true;
			clearTime();
			if(startCall is Function) startCall(this); //开始播放回调
		}
		
		private function clearTime():void
		{
			if (_setTime >= 0) {
				clearTimeout(_setTime);
				_setTime = -1;
			}
		}
		
		//为帧添加函数    为了保证效率，不添加列表响应函数
		public function addCallToFrame(call:Function, frame:uint = 1):void 
		{
			if (undefined == _frameFunKey[frame]) _frameFunKey[frame] = call;
		}
		
		//删除函数
		public function removeFrameCall(frame:int = -1):void
		{
			if (frame <= 0) {
				for (var inds:* in _frameFunKey) removeFrameCall(inds);
			}else {
				if (undefined == _frameFunKey[frame]) return;
				delete _frameFunKey[frame];
			}
		}
		
		public function callFrame(frame:uint = 1):void
		{
			var called:Function = _frameFunKey[frame];
			if (called is Function) {
				called.apply(null, parameter);
			}
		}
		
		public function getMovie():MovieClip
		{
			return _movie;
		}
		
		//时间播放 最少和当前帧一样
		public function update():void
		{
			if (playNum <= 0) return;
			if (_isPlay) {
				if (getTimer() - _startTime >= intervalTime) {
					if (_movie.currentFrame == _movie.totalFrames) {
						if (--playNum <= 0) free(true);
						else _movie.gotoAndStop(1);
					}else _movie.nextFrame();
					//
					callFrame(_movie.currentFrame);
					_startTime = getTimer();
				}
			}
		}
		
		public function free(isCall:Boolean = false):void
		{
			stoped();
			clearTime();
			removeFrameCall();
			if (isCall && onComplete is Function) onComplete.apply(null, parameter);
			if (isWeak) TweenMovie.killof(_movie);
		}
		
		public function stoped():void 
		{
			_movie.stop();
			_isPlay = false;
		}
		
		//
		private static var _MovieKey:Dictionary = new Dictionary; 
		private static var _sprite:Sprite;
		
		static public function to(target:MovieClip, data:Object,...args):TweenMovie
		{
			return new TweenMovie(target, data, args);
		}
		
		static protected function addMovie(target:MovieClip,tween:TweenMovie):void
		{
			if (undefined == _MovieKey[target]) _MovieKey[target] = tween;
		}
		
		static protected function update(e:Event = null):void
		{
			for each(var tween:TweenMovie in _MovieKey)
			{
				tween.update();
			}
		}
		
		static protected function tweenForListener(target:MovieClip,tween:TweenMovie):void
		{
			if (null == _sprite) {
				_sprite = new Sprite;
				_sprite.addEventListener(Event.ENTER_FRAME, update);
			}
			addMovie(target, tween);
		}
		
		static protected function tweenForRemove():void
		{
			if (_sprite) {
				_sprite.removeEventListener(Event.ENTER_FRAME, update);
				_sprite = null;
			}
		}
		
		static public function killof(target:MovieClip, isCall:Boolean = false):void
		{
			var tween:TweenMovie = _MovieKey[target];
			if (tween) {
				_MovieKey[target] = null;
				delete _MovieKey[target];
				tween.free(isCall);
			}
		}
		
		static public function killAll(isClall:Boolean = false):void 
		{
			for (var movie:* in _MovieKey) {
				killof(movie, isClall);
			}
			tweenForRemove();
		}
		
		//
	}

}