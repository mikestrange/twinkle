package org.alg.utils 
{
	import flash.geom.Point;

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
		public static function directionAngle(node:Point, other:Point):Number
		{
			return Math.atan2(-(node.y - other.y), -(node.x - other.x)) * 180 / Math.PI;
		}
		
		//
		public static function getPoint(node:Point, other:Point):int
		{
			var point:int = directionAngle(node, other);
			//trace("方向：",point)
			if (point < NONE) point = ROUND + point;
			switch(true)
			{
				case UP.inThis(point): 			return UP.type;
				case RIGHT_UP.inThis(point):	return RIGHT_UP.type;
				case RIGHT.inThis(point):		return RIGHT.type;
				case RIGHT_DOWN.inThis(point):	return RIGHT_DOWN.type;
				case DOWN.inThis(point):		return DOWN.type;
				case LEFT_DOWN.inThis(point):	return LEFT_DOWN.type;
				case LEFT.unThis(point):		return LEFT.type;
				case LEFT_UP.inThis(point):		return LEFT_UP.type;
			}
			return 0;
		}
		
		//ends
	}
}