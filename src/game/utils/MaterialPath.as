package game.utils 
{
	import org.alg.utils.MapPath;
	public class MaterialPath 
	{
		
		public static function getUrlByType(type:int):String
		{
			return MapPath.ROOT_URL + "ui/001_player.swf";
		}
		
		public static function getEffByType(type:int = -1):String
		{
			return MapPath.ROOT_URL + "eff/" + type+".swf";
		}
		
		
		//ends
	}

}