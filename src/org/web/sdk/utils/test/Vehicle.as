package org.web.sdk.utils.test 
{
	import flash.display.Sprite;
	import org.web.sdk.utils.Vector2D;
	
	public class Vehicle extends Sprite 
	{
		public static const WRAP:String = "wrap";
		public static const BOUNCE:String = "bounce";
		
		//边缘行为  默认移除
		protected var _edgeBehavior:String = null;
		//最大速度
		protected var _mass:Number = 1.0;
		protected var _maxSpeed:Number = 10;
		protected var _position:Vector2D;
		protected var _velocity:Vector2D;
		
		public function Vehicle() 
		{
			_position = new Vector2D();
			_velocity = new Vector2D();
			draw();
		}
		
		protected function draw():void
		{
			graphics.clear();
			graphics.lineStyle(0);
			graphics.moveTo(10, 0);
			graphics.lineTo(-10, 5);
			graphics.lineTo(-10, -5);
			graphics.lineTo(10, 0);
		}
		
		public function update():void
		{
			_velocity.truncate(_maxSpeed);
			_position = _position.add(_velocity);
			switch(_edgeBehavior) {
				case WRAP:
					wrap();
					break;
				case BOUNCE:
					bounce();
					break;
				default:
					none();
				break;
			}
			x = position.x;
			y = position.y;
			rotation = _velocity.angle * 180 / Math.PI;
		}
		
		private function bounce():void
		{
			if(stage != null)
			{
				if(position.x > stage.stageWidth)
				{
					position.x = stage.stageWidth;
					velocity.x *= -1;
				}
				else if(position.x < 0)
				{
					position.x = 0;
					velocity.x *= -1;
				}
				
				if(position.y > stage.stageHeight)
				{
					position.y = stage.stageHeight;
					velocity.y *= -1;
				}
				else if(position.y < 0)
				{
					position.y = 0;
					velocity.y *= -1;
				}
			}
		}
		
		private function wrap():void
		{
			if(stage != null)
			{
				if(position.x > stage.stageWidth) position.x = 0;
				if(position.x < 0) position.x = stage.stageWidth;
				if(position.y > stage.stageHeight) position.y = 0;
				if(position.y < 0) position.y = stage.stageHeight;
			}
		}
		
		private function none():void
		{
			if(stage != null)
			{
				if (position.x < 0 || position.x > stage.stageWidth ||
				position.y > stage.stageHeight || position.y < 0) {
					dispose();
				}
			}
		}
		
		public function dispose():void
		{
			
		}
		
		public function set edgeBehavior(value:String):void
		{
			_edgeBehavior = value;
		}
		public function get edgeBehavior():String
		{
			return _edgeBehavior;
		}
		
		public function set mass(value:Number):void
		{
			_mass = value;
		}
		
		public function get mass():Number
		{
			return _mass;
		}
		
		public function set maxSpeed(value:Number):void
		{
			_maxSpeed = value;
		}
		
		public function get maxSpeed():Number
		{
			return _maxSpeed;
		}
		
		public function set position(value:Vector2D):void
		{
			_position = value;
			x = _position.x;
			y = _position.y;
		}
		
		public function get position():Vector2D
		{
			return _position;
		}
		
		public function set velocity(value:Vector2D):void
		{
			_velocity = value;
		}
		public function get velocity():Vector2D
		{
			return _velocity;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
			_position.x = x;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			_position.y = y;
		}
		//ENDS
	}

}