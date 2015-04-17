package org.web.sdk.display.game.role 
{
	import org.web.sdk.display.paddy.covert.FormatMethod;
	import org.web.sdk.display.paddy.covert.SmartRender;
	import org.web.sdk.display.paddy.RayAnimation;
	import org.web.sdk.display.paddy.Texture;
	import org.web.sdk.global.string;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 人物组成部分
	 */
	public class RolePart extends RayAnimation 
	{
		private var _point:int = 0;
		private var _state:String;
		private var _namespaces:String;
		
		//一个需要的swf素材路径
		public function RolePart(namespaces:String)
		{
			_namespaces = namespaces;
		}
		
		//设置状态，可以牵制刷新
		public function setState(state:String, points:int = 0, value:Boolean = false):void
		{
			//解析动作
			const action:String = string.format(state + "_%t%t.png", points);
			if (action == getAction() && !value) return;
			_state = state;
			_point = points;
			setAction(action);
		}
		
		//命名空间
		override protected function getNamespace():String 
		{
			return "http://127.0.0.1/game/asset/ui/001_player.swf";
		}
		
		public function get point():int
		{
			return _point;
		}
		
		public function get state():String
		{
			return _state;
		}
		
		//ends
	}

}