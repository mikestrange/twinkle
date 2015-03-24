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
		
		override protected function showEvent(e:Object = null):void 
		{
			super.showEvent(e);
			var t:int = getTimer();
			var dis:RayDisplayer = ScaleSprite.byPoint("panelBg1", 320,140, 400,400);
			this.addDisplay(dis);
			//
			var btn:BaseButton = new BaseButton("btn_b_down", "btn_b_keep", "btn_b_over","btn_b_die");
			btn.setAlign("center");
			this.addDisplay(btn);
			var fun:Function = function(event:Object):void
			{
				btn.setEnabled(false);
				btn.setEnabled(true);
			}
			btn.setProvoke(fun);
		}
		
		//end
	}

}