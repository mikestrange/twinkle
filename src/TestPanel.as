package  
{
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import org.web.sdk.display.core.ActiveSprite;
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
			var dis:RayDisplayer = ScaleSprite.createByPointY("panelBg2", 120, 800);
			this.addDisplay(dis);
			trace(getTimer() - t);
			dis.scaleX = dis.scaleY = .8;
			//弹出方式
			TweenLite.to(dis, .2, {x:10,y:10 , scaleX:1, scaleY:1 } );
		}
		
		//end
	}

}