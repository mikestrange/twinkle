package org.web.sdk.display.core 
{
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.asset.MovieRender;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.engine.Steper;
	
	/*
	 * 更快速度的MovieClip
	 * 
	 * */
	public class RayMovieClip extends RayDisplayer 
	{
		private var _vector:Vector.<BitmapData>;
		private var _isstop:Boolean = true;
		private var _index:int = 1;		
		private var _hearttime:int = 100;		//24帧
		private var _current:int = 0;			//当前帧	
		private var _totals:int = 1;			//总帧
		//添加一个粒子控制器
		private var _step:Steper;	
		
		public function RayMovieClip(libs:MovieRender = null)
		{
			_step = new Steper(this);
			super(libs);
		}
		
		//每次在重新渲染的时候会暂停或者播放
		public function setFrames(vector:Vector.<BitmapData>):void
		{
			_vector = vector;
			if (_vector) _totals = _vector.length;
			else _totals = 1;
			//停止的时候设置
			if (_isstop) {
				stop();
			}else {
				play();
			}
		}
		
		public function restore():void
		{
			_current = getTimer();
		}
		
		public function stop(index:int = 1):void
		{
			_isstop = true;
			position = index;
			_step.die();
		}
		
		public function play(index:int = 1):void
		{
			_isstop = false;
			restore();
			position = index;
			_step.run();
		}
		
		public function isStop():Boolean
		{
			return _isstop;
		}
		
		override protected function renderBuffer(assets:*):void 
		{
			if (assets == null) return;
			setFrames(assets as Vector.<BitmapData>);
		}
		
		//循环渲染
		override public function frameRender(float:int = 0):void 
		{
			if (_isstop) return;
			if (getTimer() - _current >= _hearttime) {
				_current = getTimer();
				position++;
			}
		}
		
		//动作可以初始化
		public function set position(index:int):void
		{
			if (_vector == null || _vector.length == 0) return;
			if (index < 1) index = _totals;
			if (index > _totals) index = 1;
			this._index = index;
			this.bitmapData = _vector[_index - 1];
			this.smoothing = true;
			handlerFrame();
		}
		
		//自身处理一个帧函数
		protected function handlerFrame():void
		{
			
		}
		
		public function get position():int
		{
			return _index;
		}
		
		public function get totals():int
		{
			return _totals;
		}
		
		public function set frameRate(value:int):void
		{
			_hearttime = value;
		}
		
		public function get frameRate():int
		{
			return _hearttime;
		}
		
		override public function dispose():void 
		{
			this.stop();
			super.dispose();
		}
		//ends
	}

}