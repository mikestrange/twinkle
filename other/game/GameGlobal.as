package game 
{
	public class GameGlobal 
	{
		public static const ROOT_URL:String = "";
		public static const isDebug:Boolean = true;
		//end
		
		public static function getURL(childe:String):String
		{
			return ROOT_URL + childe;
		}
		//ends
	}

}