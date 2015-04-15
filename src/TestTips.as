package  
{
	import org.web.sdk.admin.AlertManager;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.core.stock.Alert;
	import org.web.sdk.display.core.utils.ScaleSprite;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.effect.DisplayEffects;
	import org.web.sdk.display.form.RayObject;
	import org.web.sdk.frame.core.ClientServer;
	import org.web.sdk.global.tool.Ticker;
	import org.web.sdk.interfaces.rest.IAlert;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 一个测试的tips
	 */
	public class TestTips extends Alert
	{
		
		override public function show(type:int, data:Object):void 
		{
			super.show(type, data);
			AppWork.director.getRoot().addDisplay(this);
			create_bg();
			//被添加
			this.alpha = 0;
			Ticker.step(30, DisplayEffects.pervasion, 1, this);
		}
		
		private function create_bg():void
		{
			var bg:RayObject = ScaleSprite.byPoint("TipsBack2", 194/2, 16, 380, 350);
			this.addDisplay(bg);
		}
		
		//end
	}

}