package org.web.rpg.utils 
{
	import flash.geom.Point;
	import org.web.rpg.utils.octa.OctaPoint;
	import org.web.sdk.utils.Maths;
	/*
	 * 根据角色返回方向
	 * */
	public class FormatUtils 
	{
		public static const PI_ANGLE:int = 180;
		public static const SMALL:int = 45 / 2;
		public static const ROUND:int = 360;
		public static const NONE:int = 0;
		//
		private static var UP:OctaPoint = new OctaPoint(90 - SMALL, 90 + SMALL, 0);
		private static var RIGHT_UP:OctaPoint = new OctaPoint(90 + SMALL, 180 - SMALL, 1);
		private static var RIGHT:OctaPoint = new OctaPoint(180 - SMALL, 180 + SMALL, 2);
		private static var RIGHT_DOWN:OctaPoint = new OctaPoint(180 + SMALL, 270 - SMALL, 3);
		private static var DOWN:OctaPoint = new OctaPoint(270 - SMALL, 270 + SMALL, 4);
		private static var LEFT_DOWN:OctaPoint = new OctaPoint(270 + SMALL, 360 - SMALL, 5);
		private static var LEFT:OctaPoint = new OctaPoint(SMALL,360 - SMALL, 6);
		private static var LEFT_UP:OctaPoint = new OctaPoint(SMALL, 90 - SMALL, 7);
		
		 //取精确地角度   这个物体需要水平放置
		public static function atanAngle(node:Point, other:Point):Number
		{
			return Math.atan2(other.y - node.y, other.x - node.x) * PI_ANGLE / Math.PI;
		}
		
		//取8个方向
		public static function getPoint(node:Point, other:Point):int
		{
			//角度
			var angle:int = atanAngle(node, other);
			//trace("方向：",point)
			if (angle < NONE) angle = ROUND + angle;
			
			return getIndexByAngle(angle);
		}
		
		//直接根据角度取
		public static function getIndexByAngle(angle:Number):int
		{
			switch(true)
			{
				case UP.inThis(angle): 			return UP.type;
				case RIGHT_UP.inThis(angle):	return RIGHT_UP.type;
				case RIGHT.inThis(angle):		return RIGHT.type;
				case RIGHT_DOWN.inThis(angle):	return RIGHT_DOWN.type;
				case DOWN.inThis(angle):		return DOWN.type;
				case LEFT_DOWN.inThis(angle):	return LEFT_DOWN.type;
				case LEFT.unThis(angle):		return LEFT.type;
				case LEFT_UP.inThis(angle):		return LEFT_UP.type;
			}
			return NONE;
		}
		
		//ends
	}
}
