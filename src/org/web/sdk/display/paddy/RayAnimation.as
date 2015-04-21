package org.web.sdk.display.paddy 
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.web.sdk.display.paddy.RayObject;
	import org.web.sdk.display.paddy.covert.FormatMethod;
	import org.web.sdk.display.paddy.covert.TexturePacker;
	import org.web.sdk.display.paddy.covert.SmartRender;
	import org.web.sdk.display.paddy.build.SheetPeasants;
	/*
	 * 更快速度的MovieClip
	 * 动画，初始化的时候应该设置一个动作库
	 * */
	public class RayAnimation extends RayObject 
	{
		protected static const LIM:int = 1;
		//
		private var _currentFrame:int = 0;		
		private var _hearttime:int = 100;		
		private var _currentTime:int = 0;			//当前帧
		private var _action:String = null;
		private var _vectors:Vector.<Texture>;
		//添加一个粒子控制器
		
		public function restore():void
		{
			_currentTime = getTimer();
		}
		
		public function setTextures(data:Vector.<Texture>):void
		{
			_vectors = data;
			setCurrentFrame(_currentFrame);
		}
		
		public function stop(frame:int = LIM):void
		{
			setCurrentFrame(frame);
			setRunning();
		}
		
		public function play(frame:int = LIM, action:String = null):void
		{
			_action = action;
			_currentFrame = frame;
			restore();
			this.setRunning(true);
		}
		
		public function getAction():String
		{
			return _action;
		}
		
		public function setAction(acName:String):void
		{
			play(LIM, acName);
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
			if (getTimer() - _currentTime >= _hearttime)
			{
				frameRender();
			}
		}
		
		//真正执行
		override public function frameRender(float:int = 0):void 
		{
			restore();
			nextFrame();
		}
		
		public function setCurrentFrame(index:int):void
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
			setCurrentFrame(++_currentFrame);
		}
		
		public function prevFrame():void
		{
			setCurrentFrame(--_currentFrame);
		}
		
		//无论是单材质还是多材质都可以
		override public function retakeTarget(data:Object):void 
		{
			setTextures(data as Vector.<Texture>);
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
		
		/*
		override protected function getNewRender(data:FormatMethod):SmartRender 
		{
			const vectors:Vector.<Texture> = SheetPeasants.fromVector(data.getFormat(), data.getNamespace());
			if (null == vectors) return null;
			return new TexturePacker(data.getResName(), vectors);
		}*/
		//ends
	}

}