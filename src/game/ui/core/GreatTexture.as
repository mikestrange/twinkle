package game.ui.core 
{
	import org.web.sdk.gpu.actions.ActionMovie;
	import org.web.sdk.gpu.actions.texture.ActionTexture;
	import org.web.sdk.gpu.core.CreateTexture;
	import org.web.sdk.gpu.core.TextureConductor;
	
	public class GreatTexture extends ActionMovie 
	{
		private var _point:int;
		private var _action:String;
		private var _mark:String;
		
		//全面的动作
		public function GreatTexture(type:String, point:int = 0, action:String = null, defName:String = null) 
		{
			super(defName);
			this.setConductor(CreateTexture.getFactory(type, ActionTexture));
			this._point = point;
			this._action = action;
			setAction(_action);
		}
		
		//下载也是设置，设置下载就表示当前取库
		public function load(url:String):void
		{
			ActionTexture(getTexure()).load(url, this, url);
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
			currentName = _action + "_" + _point;
			var texture:ActionTexture = getTexure() as ActionTexture;
			if (!texture.hasAction(currentName)) {
				texture.addAction(currentName, CreateTexture.getActionVectors(_action, _point, _mark));
			}
		}
		
		//不同下载都不同设置
		override public function adaptFor(mark:String, conductor:TextureConductor):void 
		{
			if (mark) {
				_mark = mark;
				setAction(_action);
			}
		}
		
		public function setMark(value:String):void
		{
			this._mark = value;
		}
		
		public function getMark():String
		{
			return _mark;
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