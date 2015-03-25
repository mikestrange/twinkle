package  
{
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import org.web.sdk.display.core.ActiveSprite;
	import org.web.sdk.display.core.BaseButton;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.core.scale.ScaleSprite;
	import org.web.sdk.display.text.TextEditor;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.FrameWork;
	import org.web.sdk.tool.Scale9Bitmap;
	
	public class TestPanel extends ActiveSprite
	{
		
		override protected function showEvent():void 
		{
			var t:int = getTimer();
			//没被添加到舞台就释放不了
			var dis:RayDisplayer = ScaleSprite.byPoint("panelBg1", 320,140, 800,400);
			this.addDisplay(dis);
			var text:TextEditor = TextEditor.quick("HeroTie", this, 30, 0xffff00);
			text.setAlign(AlignType.CENTER_TOP, 0, 20);
			//
			var btn:BaseButton = new BaseButton("btn_b_down", "btn_b_keep", "btn_b_over","btn_b_die");
			btn.setAlign("center");
			btn.moveTo(100, 100);
			this.addChild(btn);
			var ontouch:Function = function(e:Object):void
			{
				trace("点击")
				this.getFather().removeFromFather();
			}
			btn.setProvoke(ontouch);
		}
		
		override protected function hideEvent():void 
		{
			super.hideEvent();
			this.finality();
		}
		
		//end
	}

}