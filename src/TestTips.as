package  
{
	import org.web.sdk.admin.AlertManager;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.core.com.interfaces.IElement;
	import org.web.sdk.display.core.com.scroll.ScrollSprite;
	import org.web.sdk.display.core.stock.Alert;
	import org.web.sdk.display.core.TextEditor;
	import org.web.sdk.display.core.utils.ScaleSprite;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.effect.DisplayEffects;
	import org.web.sdk.display.form.core.RayButton;
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
			create_close();
			create_scroll();
			//被添加
			this.alpha = 0;
			Ticker.step(30, DisplayEffects.pervasion, 1, this);
		}
		
		private function create_bg():void
		{
			var bg:RayObject = ScaleSprite.byPoint("TipsBack2", 194/2, 16, 380, 350);
			this.addDisplay(bg);
		}
		
		private function create_close():void
		{
			var close:RayButton = new RayButton("b_close_%t")
			close.touchHandler = function(event:Object):void
			{
				removeFromAdmin();
			}
			this.addDisplay(close);
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
		//end
	}

}