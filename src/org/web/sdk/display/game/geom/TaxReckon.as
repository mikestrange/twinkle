package org.web.sdk.display.game.geom 
{
	import flash.geom.Point;
	import org.web.sdk.global.maths;
	/*
	 * 根据角色返回方向
	 * */
	public class TaxReckon 
	{
		public static const PI_ANGLE:int = 180;
		public static const SMALL:int = 45 / 2;
		public static const ROUND:int = 360;
		public static const NONE:int = 0;
		//
		private static var UP:Region = new Region(90 - SMALL, 90 + SMALL, 0);
		private static var RIGHT_UP:Region = new Region(90 + SMALL, 180 - SMALL, 1);
		private static var RIGHT:Region = new Region(180 - SMALL, 180 + SMALL, 2);
		private static var RIGHT_DOWN:Region = new Region(180 + SMALL, 270 - SMALL, 3);
		private static var DOWN:Region = new Region(270 - SMALL, 270 + SMALL, 4);
		private static var LEFT_DOWN:Region = new Region(270 + SMALL, 360 - SMALL, 5);
		private static var LEFT:Region = new Region(SMALL,360 - SMALL, 6);
		private static var LEFT_UP:Region = new Region(SMALL, 90 - SMALL, 7);
		
		 //取精确地角度   这个物体需要水平放置
		public static function atanAngle(node:Point, other:Point):Number
		{
			return Math.atan2(other.y - node.y, other.x - node.x) * PI_ANGLE / Math.PI;
		}
		
		//取8个方向
		public static function getPoint(node:Point, other:Point):int
		{
			return getIndexByAngle(atanAngle(node, other));
		}
		
		/*
		 *   7  0  1
		 * 	   \|/
		 * 	 6 - - 2
		 * 	   /|\
		 *    5 4 3
		 * */  
		//直接根据角度取
		public static function getIndexByAngle(angle:Number):int
		{
			const roundAngle:Number = maths.roundAngle(angle);
			switch(true)
			{
				case UP.inThis(roundAngle): 			return UP.type;
				case RIGHT_UP.inThis(roundAngle):		return RIGHT_UP.type;
				case RIGHT.inThis(roundAngle):			return RIGHT.type;
				case RIGHT_DOWN.inThis(roundAngle):		return RIGHT_DOWN.type;
				case DOWN.inThis(roundAngle):			return DOWN.type;
				case LEFT_DOWN.inThis(roundAngle):		return LEFT_DOWN.type;
				case LEFT.unThis(roundAngle):			return LEFT.type;
				case LEFT_UP.inThis(roundAngle):		return LEFT_UP.type;
			}
			return NONE;
		}
		
		//ends
	}
}
