package org.web.sdk.display.ray 
{
	import flash.display.BitmapData;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.asset.KitMovie;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.engine.Steper;
	
	/*
	 * 更快速度的MovieClip
	 * */
	public class RayMovieClip extends RayDisplayer 
	{
		private var _vector:Vector.<BitmapData>;
		private var _isstop:Boolean = true;
		private var _index:int = 1;		
		private var _fps:int = 5;
		private var _currfps:int = 0;
		private var _totals:int = 0;
		//添加一个粒子控制器
		private var _step:Steper;	
		
		public function RayMovieClip(libs:KitMovie = null)
		{
			_step = new Steper(this);
			super(libs);
		}
		
		public function setFrames(vector:Vector.<BitmapData>):void
		{
			_vector = vector;
			if (_vector) _totals = _vector.length;
			else _totals = 1;
		}
		
		public function restore():void
		{
			_currfps = 0;
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
			if (++_currfps > _fps) {
				_currfps = 0;
				position++;
			}
		}
		
		//动作可以初始化
		public function set position(value:int):void
		{
			if (_vector == null || _vector.length < 2) return;
			if (value < 1) value = 1;
			if (value > _totals) value = 1;
			_index = value;
			this.bitmapData = _vector[_index - 1];
			this.smoothing = true;
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
			_fps = value;
		}
		
		public function get frameRate():int
		{
			return _fps;
		}
		
		override public function dispose():void 
		{
			this.stop();
			super.dispose();
		}
		//ends
	}

}