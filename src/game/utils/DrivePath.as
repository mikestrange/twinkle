package game.utils 
{
	import org.web.rpg.utils.MapPath;
	
	public class DrivePath 
	{
		public static const ROOT_URL:String = "http://127.0.0.1/game/asset/";
		
		public static function getUrlByType(type:int):String
		{
			return ROOT_URL + "ui/001_player.swf";
		}
		
		public static function getEffByType(type:int = -1):String
		{
			return ROOT_URL + "eff/" + type+".swf";
		}
		
		//ends
	}

}