package  
{
	import com.greensock.TweenLite;
	import org.web.sdk.admin.WinManager;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.base.AppDirector;
	import org.web.sdk.display.base.GamePanel;
	import org.web.sdk.display.core.TextEditor;
	import org.web.sdk.display.core.utils.ScaleSprite;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.effect.DisplayEffects;
	import org.web.sdk.display.paddy.RayObject;
	import org.web.sdk.display.utils.Swapper;
	import org.web.sdk.interfaces.rest.IPanel;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 简单的测试面板
	 */
	public class TestPanel extends GamePanel
	{
		/* INTERFACE org.web.sdk.interfaces.rest.IPanel */
		override public function onEnter(name:String, data:Object):void 
		{
			super.onEnter(name, data);
			AppDirector.gets().root.addDisplay(this);
			//设置自身的宽高是很有必要的
			setSize(714, 600);
			//延迟呈现
			create_black();
			//delayRender(50, create_black, create_btn, create_close);
			//添加到显示  算出一个偏移就可以了
			DisplayEffects.pervasion(this);
		}
		
		//添加背景
		private function create_black():void
		{
			var bg:RayObject = ScaleSprite.byPointY("panelBg1", 150, 600);
			this.addDisplay(bg);
		}
		
		
		private function hidetween(event:Object):void 
		{
			DisplayEffects.shutting(this, .8, .1, this.removeFromAdmin);	
		}
		
		//ends
	}

}