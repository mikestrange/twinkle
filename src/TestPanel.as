package  
{
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.web.sdk.display.core.ActiveSprite;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.core.scale.ScaleSprite;
	import org.web.sdk.display.text.TextEditor;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.FrameWork;
	
	public class TestPanel extends ActiveSprite
	{
		
		override protected function showEvent(e:Object = null):void 
		{
			super.showEvent(e);
			
			var scle:ScaleSprite = new ScaleSprite(FrameWork.getAsset("panelBg2") as BitmapData);
			scle.setPoint(200, 100);
			scle.setSize(700, 600);
			scle.moveTo(10,10)
			this.addDisplay(scle);
			var item:TextEditor = new TextEditor;
			item.addText("英雄面板",false,0xffff00,30);
			item.addUnder(scle);
			item.setAlign(AlignType.CENTER_TOP, 0, 10);
			
			scle.scaleX=scle.scaleY = .8
			TweenLite.to(scle, .2, { scaleX:1, scaleY:1 } );
		}
		
		//end
	}

}