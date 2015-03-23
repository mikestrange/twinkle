package  
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import org.web.sdk.display.core.ActiveSprite;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.core.scale.ScaleSprite;
	import org.web.sdk.FrameWork;
	
	public class TestPanel extends ActiveSprite
	{
		
		override protected function showEvent(e:Object = null):void 
		{
			super.showEvent(e);
			
			var scle:ScaleSprite = new ScaleSprite(FrameWork.getAsset("panelBg1") as BitmapData);
			scle.setPoint(340, 120);
			scle.setSize(1000, 400);
			this.addDisplay(scle);
		}
		
		//end
	}

}