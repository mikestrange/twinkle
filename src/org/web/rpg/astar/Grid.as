package org.web.rpg.astar 
{
	import flash.utils.Dictionary;

	public class Grid 
	{
		//寻路大小
		private var _sizeW:int = 30;
		private var _sizeH:int = 30;
		//节点 横竖
		private var _wleng:int = 100;
		private var _hleng:int = 100;
		//所有
		private var _mapList:Dictionary;
		
		//节点尺寸无法改变
		public function Grid(nodew:int = 30, nodeh:int = 30)
		{
			_sizeW = nodew;
			_sizeH = nodeh;
			_mapList = new Dictionary;
		}
		
		//可以设置为默认网格
		public function defaultEach():void
		{
			clear();
			var node:Node;
			for (var i:int = 0; i < _hleng; i++ )
			{
				for (var j:int = 0; j < _wleng; j++ ) 
				{
					node = new Node(j, i);
					_mapList[node.id] = node;
				}
			}
		}
		
		//-----
		public function clear():void
		{
			for (var id:* in _mapList) {
				delete _mapList[id];
			}
			_mapList = new Dictionary;
		}
		
		//也可以设置
		public function addNode(x:int, y:int, type:int = 0):void
		{
			var node:Node = new Node(x, y);
			node.setType(type);
			_mapList[node.id] = node;
		}
		
		//快速取
		public function getNode(x:int, y:int):Node
		{
			return _mapList[x + "x" + y];
		}
		
		//节点尺寸
		public function get nodeWidth():int
		{
			return _sizeW;
		}
		
		public function get nodeHeight():int
		{
			return _sizeH;
		}
		
		//竖轴长度
		public function get vertical():int
		{
			return _hleng;
		}
		
		//横轴长度
		public function get across():int
		{
			return _wleng;
		}
		
		public function set vertical(value:int):void
		{
			_hleng = value;
		}
		
		public function set across(value:int):void
		{
			_wleng = value;
		}
		
		public function toString():String
		{
			var char:String = "";
			for (var i:int = 0; i < vertical; i++)
			{
				for (var j:int = 0; j < across; j++)
				{
					char += this.getNode(j, i).type+" ";
				}
				char += "\n";
			}
			return char;
		}
		
		
		//一维 转换 grid y↓  x→
		public static function createByArray(arr:Array, across:int, vertical:int, nodew:int = 30, nodeh:int = 30):Grid
		{
			var grid:Grid = new Grid(nodew, nodeh);
			grid.across = across;
			grid.vertical = vertical;
			var index:int = -1;
			for (var i:int = 0; i < grid.vertical; i++)
			{
				for (var j:int = 0; j < grid.across; j++)
				{
					grid.addNode(j, i, arr[++index]);
					//trace("y=",i,",x=" , j,",type=", arr[index]);
				}
			}
			return grid;
		}
		
		//二维 转换 grid  y↓  x→
		public static function createByDouble(arr:Array, nodew:int = 30, nodeh:int = 30):Grid
		{
			var grid:Grid = new Grid(nodew, nodeh);
			grid.across = arr[0].length;
			grid.vertical = arr.length;
			for (var i:int = 0; i < grid.vertical; i++)
			{
				for (var j:int = 0; j < grid.across; j++)
				{
					grid.addNode(j, i, arr[i][j]);
					//trace("y=",i,",x=" , j,",type=", arr[i][j]);
				}
			}
			return grid;
		}
		
		//
	}
}