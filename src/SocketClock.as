package  
{
	import org.web.sdk.tool.Clock;
	/**
	 * ...
	 * @author Main
	 */
	public class SocketClock 
	{
		
		private static var index:int = 0;
		
		public static function start():void
		{
			Clock.step(1000, clock, 0);
		}
		
		private static function clock():void
		{
			index++;
			trace("clock:", index);
		}
		
		//ends
	}

}