package org.web.sdk.display.form 
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.web.sdk.display.form.ActionMethod;
	import org.web.sdk.display.form.lib.ResRender;
	import org.web.sdk.display.form.RayObject;
	/*
	 * 更快速度的MovieClip
	 * 动画，在封装的资源下，我们不太知道动画多少帧
	 * */
	public class RayAnimation extends RayObject 
	{
		private static const LIM:int = 1;
		//
		private var _currentFrame:int = 1;		
		private var _hearttime:int = 100;		
		private var _current:int = 0;			//当前帧
		private var _action:String;
		private var _vectors:Vector.<Texture>;
		//添加一个粒子控制器
		
		public function restore():void
		{
			_current = getTimer();
		}
		
		public function stop(index:int = LIM):void
		{
			setPosition(index);
			setRunning();
		}
		
		public function play(index:int = LIM, action:String = null):void
		{
			_action = action;
			restore();
			setPosition(index);
			setRunning(true);
		}
		
		public function getAction():String
		{
			return _action;
		}
		
		public function setAction(name:String):void
		{
			_action = name;
			restore();
			setPosition(LIM);
		}
		
		public function isstop():Boolean
		{
			return !_isrun;
		}
		
		//循环渲染
		override protected function runEnter(e:Event = null):void 
		{
			if (getTimer() - _current >= _hearttime)
			{
				restore();
				nextFrame();
			}
		}
		
		public function setPosition(index:int):void
		{
			_currentFrame = index;
			if (_vectors && _vectors.length) {
				if (_currentFrame < LIM) _currentFrame = _vectors.length;
				if (_currentFrame > _vectors.length) _currentFrame = LIM;
				setTexture(_vectors[_currentFrame - LIM]);
			}else {
				_currentFrame = 0;
			}
		}
		
		//动作可以初始化  //updateBuffer(getExchange());
		public function nextFrame():void
		{
			setPosition(_currentFrame++);
		}
		
		public function prevFrame():void
		{
			setPosition(_currentFrame--);
		}
		
		protected function setTextures(target:Vector.<Texture>):void
		{
			_vectors = target;
		}
		
		protected function getActionMethod():ActionMethod
		{
			return new ActionMethod(_action, setTextures);
		}
		
		public function get currentFrame():int
		{
			return _currentFrame;
		}
		
		public function set frameRate(value:int):void
		{
			_hearttime = value;
		}
		
		public function get frameRate():int
		{
			return _hearttime;
		}
		
		public function get totals():int
		{
			if (_vectors) return _vectors.length;
			return 0;
		}
		
		override public function dispose():void 
		{
			this.stop();
			super.dispose();
		}
		//ends
	}

}