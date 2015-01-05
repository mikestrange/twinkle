package org.web.sdk.gpu.actions 
{
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	import org.web.sdk.display.core.Texture;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.Phoebus;
	import org.web.sdk.gpu.core.GpuDisplayObject;
	import org.web.sdk.gpu.core.CreateTexture;
	import org.web.sdk.gpu.actions.texture.ActionTexture;
	import org.web.sdk.utils.HashMap;
	/*
	 * 动作集合
	 * */
	public class ActionMovie extends GpuDisplayObject
	{
		//默认动作不改变
		private var _defName:String;
		private var _actionName:String;
		private var _index:int = 0;
		private var _isstop:Boolean;
		private var _float_time:Number = 0;
		
		public function ActionMovie(defName:String = null) 
		{
			this._defName = defName;
			restore();
		}
		
		//默认动作，不能替换
		public function get defAction():String
		{
			return this._defName;
		}
		
		//恢复
		public function restore():void
		{
			this._float_time = getTimer();
		}
		
		//当前
		public function get currentName():String
		{
			return _actionName;
		}
		
		public function set currentName(value:String):void
		{
			_actionName = value;
		}
		
		public function stop(action:String, value:int = -1):void
		{
			if (_isstop) _isstop = true;
			_actionName = action;
			if (value == -1) value = _index;
			showIndex(action, value);
		}
		
		public function play(action:String = null, value:int = -1):void
		{
			if (_isstop) _isstop = false;
			if (action == null) _actionName = _defName;
			else _actionName = action;
			if (value == -1) value = _index;
			showIndex(action, value);
		}
		
		public function isPlay():Boolean
		{
			return !_isstop;
		}
		
		override public function render():void 
		{
			if (_isstop) return;
			if (getTimer() - _float_time > CreateTexture.FPS) {
				showIndex(_actionName, ++_index);
				doFrame(_index);
			}
		}
		
		//
		protected function doFrame(value:int):void 
		{
			
		}
		
		protected function showIndex(action:String, value:int):void
		{
			_index = value;
			_float_time = getTimer();
			if (!this.isValid() || action == null) {
				_index = 0;
				return;
			}
			var texture:ActionTexture = getTexure() as ActionTexture;
			var vector:Vector.<BitmapData> = texture.getActions(action);
			if (vector == null) {
				_index = 0;
				return;
			}
			if (_index >= vector.length) _index = 0;
			this.setBitmapdata(vector[_index]);
		}
		
		//动作可以初始化
		public function set position(value:int):void
		{
			showIndex(_actionName, value);
		}
		
		public function get position():int
		{
			return _index;
		}
		
		override public function setBitmapdata(bit:BitmapData, smooth:Boolean = true):void 
		{
			if (bit == null) return;
			super.setBitmapdata(bit, smooth);
		}
		//ends
	}

}