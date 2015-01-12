package org.web.sdk.gpu 
{
	import flash.utils.getTimer;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.SunEngine;
	import org.web.sdk.gpu.texture.VRayTexture;
	
	public class GpuMovie extends GpuSprite
	{
		private var _vector:Vector.<VRayTexture>;
		private var _float_time:Number = 0;
		private var _isstop:Boolean;
		private var _index:int = 0;		
		private var _fps:int;
		
		public function GpuMovie(render_time:Number = NaN)
		{
			_fps = isNaN(render_time)? GpuSprite.RENDER_FPS : render_time;
		}
		
		public function setFrames(vector:Vector.<VRayTexture>):void
		{
			_vector = vector;
		}
		
		//恢复
		public function restore():void
		{
			this._float_time = getTimer();
		}
		
		public function stop(index:int = 0):void
		{
			position = index;
			_isstop = true;
		}
		
		public function play(index:int = 0):void
		{
			_isstop = false;
			restore();
			position = index;
		}
		
		public function isStop():Boolean
		{
			return _isstop;
		}
		
		//循环渲染
		override public function render():void 
		{
			if (_isstop) return;
			if (getTimer() - _float_time > _fps) {
				_float_time = getTimer();
				position++;
			}
		}
		
		//动作可以初始化
		public function set position(value:int):void
		{
			if (_vector == null) return;
			_index = value;
			if (_index >= _vector.length) _index = 0;
			setTexture(_vector[_index]);
		}
		
		public function get position():int
		{
			return _index;
		}
		
		public function set fps(value:int):void
		{
			_fps = value;
		}
		
		public function get fps():int
		{
			return _fps;
		}
		//ends
	}

}