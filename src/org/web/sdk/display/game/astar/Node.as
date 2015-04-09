package org.web.sdk.display.game.astar 
{
	public class Node 
	{
		//节点位置
		private var _x:int;
		private var _y:int;
		//地表类型
		private var _type:int;	
		//代价
		public const costMultiplier:Number = 1;
		//父节点
		public var parent:Node;
		//代价
		public var f:Number = 0;
		public var h:Number = 0;
		public var g:Number = 0;
	
		public function Node(x:int = 0, y:int = 0, type:int = 1)
		{
			this._x = x;
			this._y = y;
			setType(type);
		}
		
		public function get x():int
		{
			return _x;
		}
		
		public function get y():int
		{
			return _y;
		}
		
		public function get id():String
		{
			return _x + "x" + _y;
		}
		
		//设置地表类型
		public function setType(value:int):void
		{
			_type = value;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		//是否可以行
		public function isWalk():Boolean
		{
			return _type != NodeType.NO_WALK;
		}
		
		//是否遮罩
		public function isMask():Boolean
		{
			return _type == NodeType.MASK;
		}
		
		//--------
		public function toString():String
		{
			var char:String = "";
			char += "[";
			char += "x=" + x;
			char += ",y=" + y;
			char += ",type=" + _type;
			char += ",parent=" + parent;
			char += "]";
			return char;
		}
		
		//ends
	}
}