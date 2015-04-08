package  
{
	import org.web.sdk.admin.TipsManager;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.game.BaseButton;
	import org.web.sdk.display.game.FewTips;
	import org.web.sdk.display.game.utils.ScaleSprite;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.effect.DisplayEffects;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.global.tool.Ticker;
	import org.web.sdk.interfaces.rest.ITips;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 一个测试的tips
	 */
	public class TestTips extends FewTips
	{
		
		override public function show(type:int, data:Object):void 
		{
			super.show(type, data);
			AppWork.director.getRoot().addChild(this);
			create_bg();
			create_close();
			//被添加
			this.alpha = 0;
			Ticker.step(30, DisplayEffects.pervasion, 1, this);
		}
		
		private function create_close():void
		{
			var btn:BaseButton = new BaseButton("a_close_up", "a_close_down", "a_close_over");
			btn.setAlign(AlignType.RIGHT);
			this.addDisplay(btn);
			//
			btn.clickHandler = function(event:Object):void
			{
				removeFromAdmin();
			}
		}
		
		
		private function create_bg():void
		{
			var bg:RayDisplayer = ScaleSprite.byPoint("TipsBack1", 40, 50, 300, 200);
			this.addDisplay(bg);
		}
		
		//end
	}

}