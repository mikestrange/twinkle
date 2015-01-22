package game.ui.core 
{
	import flash.events.Event;
	import game.ui.core.MovieShader;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.Steper;
	import org.web.sdk.gpu.GpuMovie;
	import org.web.sdk.gpu.shader.ShaderManager;
	/*
	 * 定制的一个动画，8个方向,各种动作
	 * 
	 * **每一个type都是不同的url，也许一个type下面有几个url，但是他们必须在同一个资源库下
	 * **只要一个类型存在，我们可以随时调出来，不用每次new,
	 * **一般人物动作不会超过 10几个 6个动作 8个方向就算是800KB，
	 * 同屏出现10个不同的人物，那么 10*800 8MB,那也是没有办法的，这种避免重新new，一般情况可以，也可以稍作修改
	 * */
	public class GpuCustom extends GpuMovie
	{	
		private var _point:int;
		private var _action:String;
		private var _domain:String;		//当前动作
		private var _url:String;
		private var _defaction:String;
		private var _playtimes:int = 0;
		
		//全面的动作
		public function GpuCustom(type:String, point:int = 4, action:String = null) 
		{
			if (!ShaderManager.has(type)) new MovieShader(type);
			this.setShader(type);
			this._point = point;
			this._defaction = this._action = action;
			_domain = formt();
			if (action) sendRender("render", _action);
		}
		
		public function formt():String
		{
			return _action.replace("%s", _point);
		}
		
		override public function updateRender(code:String, data:* = undefined):void 
		{
			if (code == null) return;
			setFrames(data);
		}
		
		//设置方向
		private function setPoint(value:int):void
		{
			if (value == -1) value = _point;
			if (_point == value) return;	//相同就不管
			_point = value;
			setAction(_action);
		}
		
		//设置动作  把动作分级别，取不同的URL
		private function setAction(action:String):void
		{
			if (action == null) return;
			if (action == _action) return;
			_action = action;
			_domain = formt();
			sendRender("render", _action);
		}
		
		//播放一个动作，方向，几次
		public function setActionAndPoint(action:String, value:int = -1, times:int = 0):void
		{
			if (value == -1) value = _point;
			if (action == null) action = _action;
			if (_point == value && action == _action) return;
			_playtimes = times;
			_action = action;
			_point = value;
			_domain = formt();
			sendRender("render", _action);
		}
		
		override public function render():void 
		{
			super.render();
			if (_playtimes > 0 && position == totals && --_playtimes <= 0) {
				_playtimes = 0;
				setAction(_defaction);
			}
		}
		
		public function get currentName():String
		{
			return _domain;
		}
		
		public function getPoint():int
		{
			return _point;
		}
		
		public function getAction():String
		{
			return _action;
		}
		
		//ends
	}

}