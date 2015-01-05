package org.alg.utils 
{

	public class MapPath 
	{
		private static const ROOT_URL:String = "http://127.0.0.1/game/asset/";
		//取一块
		public static function getMapURL(id:uint, name:String, suff:String = ".jpg"):String
		{
			return ROOT_URL + "imgs/maps/" + id + "/" + name + suff;
		}
		
		//小地图
		public static function getMapSmall(id:uint):String
		{
			return ROOT_URL + "imgs/maps/" + id +"/map.jpg";
		}
		
		//配置
		public static function getMapConfig(id:uint):String
		{
			return ROOT_URL + "imgs/maps/focus/" + id +".xml";
		}
		
		
		
		//ends
	}

}