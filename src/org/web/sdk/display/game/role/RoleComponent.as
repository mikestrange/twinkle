package org.web.sdk.display.game.role 
{
	import org.web.sdk.display.form.lib.AttainMethod;
	import org.web.sdk.display.form.lib.ResRender;
	import org.web.sdk.display.form.RayAnimation;
	import org.web.sdk.display.form.rule.RuleFactory;
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
		}
		
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
		
		override public function frameRender(float:int = 0):void 
		{
			super.frameRender(float);
			doEnter();
		}
		
		//test
		private const GTY:Number = 1.2;
		private var vel:Number = 0;
		private var jumpSpeed:Number = 0;
		private const speed:int = 100;
		private const NULL:int = 0;
		private var currentY:Number = 0;
		
		public function jump():void
		{
			if (jumpSpeed > NULL) return;
			currentY = this.y;
			jumpSpeed = 80;
		}
		
		private function doEnter():void
		{
			if (jumpSpeed == NULL) return;
			vel += speed / 10;
			vel *= GTY;
			var endy:Number = this.y + vel - jumpSpeed;
			if (endy >= currentY) {
				this.y = currentY;
				vel = NULL;
				jumpSpeed = NULL;
			}else {
				this.y = endy;
			}
		}
		//ends
	}

}