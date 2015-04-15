package org.web.sdk.display.game.role 
{
	import org.web.sdk.display.form.lib.ResRender;
	import org.web.sdk.display.form.lib.VectorRender;
	import org.web.sdk.display.form.RayAnimation;
	import org.web.sdk.display.form.rule.RuleFactory;
	import org.web.sdk.display.form.type.RayType;
	import org.web.sdk.global.string;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 人物组成部分
	 */
	public class RoleComponent extends RayAnimation 
	{
		private var _point:int = 0;
		private var _state:String;
		private var _namespaces:String;
		
		//一个需要的swf素材路径
		public function RoleComponent(namespaces:String)
		{
			_namespaces = namespaces;
			this.seekByName(_namespaces, RayType.ACTION_TAG, this.getMethod());
		}
		
		public function setState(state:String, points:int = 0, value:Boolean = false):void
		{
			//解析动作
			const action:String = string.format(state + "_%t%t.png", points);
			if (action == getAction() && !value) return;
			_state = state;
			_point = point;
			setAction(action);
		}
		
		override public function supplyHandler(res:ResRender):Object 
		{
			return RuleFactory.fromVector(getAction(), getNamespaces());
		}
		
		//命名空间
		public function getNamespaces():String
		{
			return _namespaces;
		}
		
		public function get point():int
		{
			return _point;
		}
		
		public function get state():String
		{
			return _state;
		}
		
		//
		
		//ends
	}

}