package org.web.sdk.utils.test
{
	import org.web.sdk.utils.Vector2D;

	public class Circle
	{
		public var x:Number;
		public var y:Number;
		private var _radius:Number;
		
		public function Circle(radius:Number)
		{
			_radius = radius;
		}
		
		public function get radius():Number
		{
			return _radius;
		}
		
		public function get position():Vector2D
		{
			return new Vector2D(x, y);
		}
		//ends
	}
}