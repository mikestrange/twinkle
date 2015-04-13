package org.web.sdk.display.form.core 
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.web.sdk.display.form.lib.ResRender;
	import org.web.sdk.display.form.RayObject;
	/*
	 * 更快速度的MovieClip
	 * 动画，在封装的资源下，我们不太知道动画多少帧
	 * */
	public class RayAnimation extends RayObject 
	{
		private var _index:int = 1;		
		private var _hearttime:int = 100;		
		private var _current:int = 0;			//当前帧	
		private var _totals:int = 1;			//总帧
		//添加一个粒子控制器
		
		public function RayAnimation(res:ResRender = null)
		{
			super(res);
		}
		
		public function restore():void
		{
			_current = getTimer();
		}
		
		public function stop(index:int = 1):void
		{
			position = index;
			setRunning();
		}
		
		public function play(index:int = 1):void
		{
			restore();
			position = index;
			setRunning(true);
		}
		
		public function isstop():Boolean
		{
			return !_isrun;
		}
		
		//循环渲染
		override protected function runEnter(e:Event = null):void 
		{
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
			//
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