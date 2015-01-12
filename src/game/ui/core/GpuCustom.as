package game.ui.core 
{
	import game.ui.core.MovieShader;
	import org.web.sdk.gpu.GpuMovie;
	import org.web.sdk.gpu.shader.ShaderManager;
	
	public class GpuCustom extends GpuMovie
	{	
		private var _point:int;
		private var _action:String;
		private var _domain:String;		//当前动作
		private var _url:String;
		
		//全面的动作
		public function GpuCustom(type:String, point:int = 4, action:String = null) 
		{
			if (!ShaderManager.has(type)) new MovieShader(type);
			this.setShader(type);
			this._point = point;
			this._action = action;
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
		
		public function setActionAndPoint(action:String, value:int = -1):void
		{
			if (value == -1) value = _point;
			if (action == null) action = _action;
			if (_point == value && action == _action) return;
			_action = action;
			_point = value;
			_domain = formt();
			sendRender("render", _action);
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