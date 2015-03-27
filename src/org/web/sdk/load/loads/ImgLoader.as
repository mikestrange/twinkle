package org.web.sdk.load.loads 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.load.LoadEvent;
	
	public class ImgLoader extends SwfLoader 
	{
		override protected function complete(e:Event):void
		{
			removeListener();
			super.invoke(e.target.loader.content.bitmapData as BitmapData, LoadEvent.COMPLETE);
		}
		
		//ends
	}

}