package  
{
	import com.greensock.TweenLite;
	import org.web.sdk.admin.WinManager;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.core.TextEditor;
	import org.web.sdk.display.core.utils.ScaleSprite;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.effect.DisplayEffects;
	import org.web.sdk.display.game.BaseButton;
	import org.web.sdk.display.game.GamePanel;
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
			AppWork.director.getRoot().addDisplay(this);
			//设置自身的宽高是很有必要的
			setLimit(714, 600);
			//延迟呈现
			create_black();
			create_btn();
			create_close();
			//delayRender(50, create_black, create_btn, create_close);
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
			var bg:RayDisplayer = ScaleSprite.byPointY("panelBg1", 150, 600);
			this.addDisplay(bg);
		}
		
		private function create_close():void
		{
			var btn:BaseButton = new BaseButton("b_close_up", "b_close_down", "b_close_over");
			btn.setAlign(AlignType.RIGHT, 30, 40);
			this.addDisplay(btn);
			btn.setScale(1.2, 1.2);
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