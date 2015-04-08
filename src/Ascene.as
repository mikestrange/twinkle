package  
{
	import org.web.sdk.display.BaseScene;
	import org.web.sdk.display.interfaces.IDirector;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.interfaces.IBaseScene;
	
	public class Ascene extends BaseScene
	{
		override public function onEnter():void 
		{
			this.addDisplay(new TestPanel);
		}
		//end
	}

}