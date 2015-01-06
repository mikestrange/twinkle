package game.ui.core.actions 
{
	import flash.display.BitmapData;
	import flash.utils.getTimer;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.SunEngine;
	import org.web.sdk.gpu.asset.CryRenderer;
	import org.web.sdk.gpu.core.GpuSprite;
	import org.web.sdk.utils.HashMap;
	/*
	 * 动作集合
	 * */
	public class GpuMovie extends GpuSprite
	{
		//默认动作不改变
		private var _index:int = 0;		
		private var _action:String;				//动作名称
		private var _isstop:Boolean;	
		private var _float_time:Number = getTimer();
		private var _vecotr:Vector.<BitmapData>;
		protected var _url:String;
		
		//立刻下载
		public function load(url:String):void
		{
			_url = url;
			sendRender("load", url);
		}
		
		//恢复
		public function restore():void
		{
			this._float_time = getTimer();
		}
		
		//当前
		public function get currentName():String
		{
			return _action;
		}
		
		public function set currentName(value:String):void
		{
			this._action = value;
		}
		
		public function stop(action:String = null, value:int = -1):void
		{
			if (_isstop) _isstop = true;
			if(action) _action = action;
			if (value == -1) value = _index;
			sendRender("render");
		}
		
		public function play(action:String = null, value:int = -1):void
		{
			if (_isstop) _isstop = false;
			if(action) _action = action;
			if (value == -1) value = _index;
			sendRender("render");
		}
		
		public function isPlay():Boolean
		{
			return !_isstop;
		}
		
		//循环渲染
		override public function render():void 
		{
			if (_isstop) return;
			if (!isValid()) return;
			if (getTimer() - _float_time > GpuSprite.RENDER_FPS) {
				showIndex(_action, ++_index);
				doFrame(_index);
			}
		}
		
		//监听帧
		protected function doFrame(value:int):void 
		{
			
		}
		
		override public function updateRender(code:String, data:* = undefined):void 
		{
			if (code == null) return;
			_vecotr = data;
		}
		
		protected function showIndex(action:String, value:int):void
		{
			_index = value;
			restore();
			if (action == null) {
				_index = 0;
				return;
			}
			if (_vecotr == null) {
				_index = 0;
				return;
			}
			if (_index >= _vecotr.length) _index = 0;
			setTexture(_vecotr[_index]);
		}
		
		//动作可以初始化
		public function set position(value:int):void
		{
			_index = value;
			sendRender("user");
		}
		
		public function get position():int
		{
			return _index;
		}
		
		//ends
	}

}