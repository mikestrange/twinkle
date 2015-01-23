package org.web.sdk.gpu 
{
	import flash.events.Event;
	import flash.utils.getTimer;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.Steper;
	import org.web.sdk.display.engine.SunEngine;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.FrameWork;
	import org.web.sdk.gpu.texture.BaseTexture;
	/*
	 * 就算包含一个sprite 效率也是movieclip的2倍,如果用3D渲染，那么效率肯定更高
	 * */
	public class GpuMovie extends GpuSprite
	{
		private var _vector:Vector.<BaseTexture>;
		private var _isstop:Boolean = true;
		private var _index:int = 1;		
		private var _fps:int = GpuSprite.RENDER_FPS;
		private var _currfps:int = 0;
		private var _totals:int = 0;
		//添加一个粒子控制器
		private var _step:Steper;	
		
		public function GpuMovie()
		{
			_step = new Steper(this);
		}
		
		public function setFrames(vector:Vector.<BaseTexture>):void
		{
			_vector = vector;
			if (_vector) _totals = _vector.length;
			else _totals = 1;
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
			if (_vector == null || _vector.length < 2) return;
			if (value < 1) value = 1;
			if (value > _totals) value = 1;
			_index = value;
			setTexture(_vector[_index - 1]);
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