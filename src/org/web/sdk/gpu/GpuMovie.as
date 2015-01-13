package org.web.sdk.gpu 
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.Steper;
	import org.web.sdk.display.engine.SunEngine;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.gpu.texture.VRayTexture;
	/*
	 * 就算包含一个sprite 效率也是movieclip的2倍,如果用3D渲染，那么效率肯定更高
	 * */
	public class GpuMovie extends GpuSprite
	{
		private var _vector:Vector.<VRayTexture>;
		private var _isstop:Boolean;
		private var _index:int = 0;		
		private var _fps:int;
		private var _currfps:int = 0;
		//添加一个粒子控制器
		private var _step:Steper;	
		
		public function GpuMovie(render_time:int = 0)
		{
			_fps = render_time == 0? GpuSprite.RENDER_FPS : Math.abs(render_time);
			_step = new Steper(this);
		}
		
		public function setFrames(vector:Vector.<VRayTexture>):void
		{
			_vector = vector;
		}
		
		public function restore():void
		{
			_currfps = 0;
		}
		
		public function stop(index:int = 0):void
		{
			_isstop = true;
			position = index;
			_step.die();
		}
		
		public function play(index:int = 0):void
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
		
		//循环渲染
		override public function render():void 
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