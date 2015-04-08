package  
{
	import com.greensock.TweenLite;
	import org.web.sdk.admin.WinManager;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.game.BaseButton;
	import org.web.sdk.display.game.GamePanel;
	import org.web.sdk.display.game.utils.ScaleSprite;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.core.text.TextEditor;
	import org.web.sdk.display.effect.DisplayEffects;
	import org.web.sdk.display.utils.AlignType;
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
			AppWork.director.getRoot().addChild(this);
			//设置自身的宽高是很有必要的
			setLimit(412, 500);
			//延迟呈现
			delayRender(50, create_black, create_btn, create_close);
			//添加到显示  算出一个偏移就可以了
			DisplayEffects.pervasion(this);
		}
		
		private function create_btn():void
		{
			var btn:BaseButton = new BaseButton("btn_b_down", "btn_b_keep", "btn_b_over", "btn_b_die");
			btn.setAlign("center");
			this.addDisplay(btn);
			//
			var text:TextEditor = TextEditor.quick("lable", null, 16, 0xffff00);
			btn.setTitle(text);
			//点击处理
			btn.clickHandler = clickHandler;
		}
		
		private function clickHandler(event:BaseButton):void		
		{
			event.setEnabled(false);
			trace("测试按钮点击");
		}
		
		//添加背景
		private function create_black():void
		{
			var bg:RayDisplayer = ScaleSprite.byPointY("panelBg2", 120, 500);
			this.addDisplay(bg);
		}
		
		private function create_close():void
		{
			var btn:BaseButton = new BaseButton("a_close_up", "a_close_down", "a_close_over");
			btn.setAlign(AlignType.RIGHT);
			this.addDisplay(btn);
			//关闭按钮
			btn.clickHandler = hidetween;
		}
		
		private function hidetween(event:Object):void 
		{
			DisplayEffects.shutting(this, .8, .1, this.removeFromAdmin);	
		}
		
		//ends
	}

}