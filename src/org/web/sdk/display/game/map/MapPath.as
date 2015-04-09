package org.web.sdk.display.game.map 
{
	//地图路径设置
	public class MapPath 
	{
		public static var ROOT_URL:String = "http://127.0.0.1/game/asset/";
		
		//地图碎片
		public static function getMapURL(id:uint, name:String, suff:String = ".jpg"):String
		{
			return ROOT_URL + "imgs/maps/" + id + "/" + name + suff;
		}
		
		//小地图/右上角的
		public static function getMapSmall(id:uint, suff:String = ".jpg"):String
		{
			return ROOT_URL + "imgs/maps/" + id +"/map" + suff;
		}
		
		//地图配置文件
		public static function getMapConfig(id:uint):String
		{
			return ROOT_URL + "imgs/maps/focus/" + id +".xml";
		}
		//ends
	}

}