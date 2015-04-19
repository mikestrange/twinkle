package  
{
	import com.greensock.TweenLite;
	import org.web.sdk.admin.PopupManager;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.base.AppDirector;
	import org.web.sdk.display.base.GamePanel;
	import org.web.sdk.display.core.com.interfaces.IElement;
	import org.web.sdk.display.core.com.scroll.ScrollSprite;
	import org.web.sdk.display.core.TextEditor;
	import org.web.sdk.display.core.utils.ScaleSprite;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.effect.DisplayEffects;
	import org.web.sdk.display.paddy.base.RayButton;
	import org.web.sdk.display.paddy.RayObject;
	import org.web.sdk.display.utils.Swapper;
	import org.web.sdk.interfaces.rest.IWindow;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 简单的测试面板
	 */
	public class TestPanel extends GamePanel
	{
		override public function getDefineName():String 
		{
			return "test";
		}
		
		/* INTERFACE org.web.sdk.interfaces.rest.IPanel */
		override public function show(data:Object = null):void 
		{
			AppDirector.gets().root.addDisplay(this);
			//设置自身的宽高是很有必要的
			setSize(380, 350);
			//延迟呈现
			create_black();
			create_close();
			create_scroll();
			//添加到显示  算出一个偏移就可以了
			DisplayEffects.pervasion(this);
		}
		private function create_close():void
		{
			var close:RayButton = new RayButton("b_close_%t")
			close.touchHandler = function(event:Object):void
			{
				DisplayEffects.shutting(this.getFather(), .8, .1, closed);
			}
			this.addDisplay(close);
		}
		
		//添加背景
		private function create_black():void
		{
			var bg:RayObject = ScaleSprite.byPoint("TipsBack2", 194/2, 16, 380, 350);
			this.addDisplay(bg);
			/*
			var bg:RayObject = ScaleSprite.byPointY("panelBg1", 150, 600);
			this.addDisplay(bg);*/
		}
		
		private var scroll:ScrollSprite;
		
		private function create_scroll():void
		{
			scroll = new ScrollSprite;
			scroll.setSize(100, 300);
		//返回行
			scroll.sizeHandler = function():int 
			{	 
				return 30;
			}
			//每一个位置的间距
			scroll.spaceHandler = function(index:int):Number
			{ 
				return 64; 
			}
			//缓冲函数
			scroll.rollHandler = rollHandler;
			scroll.updateScroll();
			scroll.moveTo(52,20)
			this.addDisplay(scroll);
		}
		
		private function rollHandler(scroll:ScrollSprite, index:int):IElement
		{
			var cell:IElement = scroll.getQueue(index);
			var ray:RayObject = new RayObject();
			ray.setCompulsory("preferentialbox_bg");
			cell.addDisplay(ray);
			TextEditor.quick(index.toString(), cell, 20, 0xffff00);
			return cell;
		}
		
		//ends
	}

}