package game.ui.role 
{
	import flash.display.Loader;
	import game.ui.core.GreatTexture;
	import org.web.sdk.FrameWork;
	import game.ui.core.actions.GpuMovie;
	import org.web.sdk.gpu.asset.CryRenderer;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	
	//角色
	public class PlayerAction extends GreatTexture
	{
		public function PlayerAction(type:String)
		{
			super(type, 4, ActionType.STAND);
		}
		//ends
	}

}