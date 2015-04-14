package org.web.sdk.display.form 
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.web.sdk.display.form.AttainMethod;
	import org.web.sdk.display.form.lib.ResRender;
	import org.web.sdk.display.form.RayObject;
	import org.web.sdk.display.form.type.RayType;
	/*
	 * 更快速度的MovieClip
	 * 动画，初始化的时候应该设置一个动作库
	 * */
	public class RayAnimation extends RayObject 
	{
		private static const LIM:int = 1;
		//
		private var _currentFrame:int = 0;		
		private var _hearttime:int = 100;		
		private var _currentTime:int = 0;			//当前帧
		private var _action:String;
		private var _vectors:Vector.<Texture>;
		//添加一个粒子控制器
		
		public function restore():void
		{
			_currentTime = getTimer();
		}
		
		public function stop(frame:int = LIM):void
		{
			setPosition(frame);
			setRunning();
		}
		
		public function play(frame:int = LIM, action:String = null):void
		{
			_action = action;
			_currentFrame = frame;
			restore();
			//这里只是获取缓存的一个材质
			updateBuffer(getMethod());
			setRunning(true);
		}
		
		public function getAction():String
		{
			return _action;
		}
		
		public function setAction(acName:String):void
		{
			_action = acName;
			_currentFrame = LIM;
			restore();
			//刷新缓存
			updateBuffer(getMethod());
		}
		
		public function isAction(acName:String):Boolean
		{
			return 	_action == acName;
		}
		
		public function isstop():Boolean
		{
			return !_isrun;
		}
		
		//循环渲染
		override protected function runEnter(e:Event = null):void 
		{
			if (getTimer() - _currentTime >= _hearttime) {
				frameRender();
			}
		}
		
		//真正执行
		override public function frameRender(float:int = 0):void 
		{
			restore();
			nextFrame();
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
		
		public function nextFrame():void
		{
			setPosition(++_currentFrame);
		}
		
		public function prevFrame():void
		{
			setPosition(--_currentFrame);
		}
		
		//无论是单材质还是多材质都可以
		public function setTextures(target:*):void
		{
			if (target is Texture) {
				_vectors = new Vector.<Texture>;
				_vectors.push(target);
			}else if (target is Vector.<Texture>) {
				_vectors = target as Vector.<Texture>;
			}else if (target is Array) {
				_vectors = Vector.<Texture>(target);
			}else {
				_vectors = null;
			}
			//重新取的时候会刷新
			setPosition(_currentFrame);
		}
		
		protected function getMethod():AttainMethod
		{
			return new AttainMethod(RayType.LIST, _action, setTextures);
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
		
		// static 这里建立单一的材质链
		public static function quick(format:String):RayAnimation
		{
			const ray:RayAnimation = new RayAnimation();
			ray.seekByName(format, RayType.VECTOR_TAG, ray.getMethod());
			return ray;
		}
		
		//动作，非动画
		public static function formatSenior(format:String):RayAnimation
		{
			const ray:RayAnimation = new RayAnimation();
			ray.seekByName(format, RayType.ACTION_TAG, ray.getMethod());
			return ray;
		}
		//ends
	}

}