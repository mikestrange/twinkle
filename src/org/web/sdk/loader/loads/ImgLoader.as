package org.web.sdk.loader.loads 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.loader.LoadEvent;
	
	public class ImgLoader extends SwfLoader 
	{
		override protected function complete(e:Event):void
		{
			removeListener();
			_isLoader = false;
			super.invoke(LoadEvent.COMPLETE, e.target.loader.content.bitmapData as BitmapData);
		}
		
		//ends
	}

}