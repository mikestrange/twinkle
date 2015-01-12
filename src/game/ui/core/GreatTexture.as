package game.ui.core 
{
	import game.ui.core.actions.GpuMovie;
	import game.ui.core.actions.MovieShader;
	import org.web.sdk.gpu.shader.ShaderManager;
	
	public class GreatTexture extends GpuMovie
	{	
		private var _point:int;
		private var _action:String;
		private var _mark:String;
		
		//全面的动作
		public function GreatTexture(type:String, point:int = 0, action:String = null) 
		{
			super();
			if (!ShaderManager.has(type)) ShaderManager.create(new MovieShader(type));
			this.setShader(type)
			this._point = point;
			this._action = action;
			setAction(_action);
		}
		
		//方向
		public function setPoint(value:int):void
		{
			if (value == -1) value = _point;
			_point = value;
			setAction(_action);
		}
		
		//动作
		public function setAction(action:String):void
		{
			if (action == null) return;
			_action = action;
			currentName = MovieShader.getActionName(_action, _point);
			sendRender("render",_url);
		}
		
		public function setActionAndPoint(action:String, value:int = -1):void
		{
			if (value == -1) value = _point;
			_point = value;
			setAction(action);
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