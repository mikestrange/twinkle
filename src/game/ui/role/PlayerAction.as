package game.ui.role 
{
	import flash.display.Loader;
	import game.ui.core.GreatTexture;
	import org.web.sdk.FrameWork;
	import org.web.sdk.gpu.actions.ActionMovie;
	import org.web.sdk.gpu.core.CreateTexture;
	import org.web.sdk.gpu.actions.texture.ActionTexture;
	import org.web.sdk.gpu.core.TextureConductor;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	
	//角色
	public class PlayerAction extends GreatTexture
	{
		public function PlayerAction(type:String)
		{
			super(type, 4, ActionType.STAND, null);
		}
		//ends
	}

}