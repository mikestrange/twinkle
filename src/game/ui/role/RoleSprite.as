package game.ui.role 
{
	import game.ui.core.ActionType;
	import game.ui.core.GpuCustom;
	import org.web.sdk.display.KitSprite;
	/*
	 * 不要随意绘制
	 * */
	public class RoleSprite extends KitSprite 
	{
		private var _action:GpuCustom;
		
		public function RoleSprite() 
		{
			this.initialization();
		}
		
		override public function initialization(value:Boolean = true):void 
		{
			_action = new GpuCustom("role", 4, ActionType.STAND);
			_action.play();
			this.addChild(_action);
		}
		
		//ends
	}

}