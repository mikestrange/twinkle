package org.web.rpg.astar 
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class Astar 
	{
		//寻路最长消耗
		public const _MAX_ELAPSED_TIME_:int = 3000;
		//
		private var _grid:Grid;
		//一个单元代价
		private var _straightCost:Number = 1;
		//斜角代价
		private var _diagCost:Number = Math.SQRT2; //对角线代价  
		//启蒙函数							耗时等级  0         2        1
		private var _handle:Function = manhattan;//manhattan,euclidian,diagonal
		//开闭列表
		private var _closed:Array;
		private var _open:Array;
		private var _path:Array;
		//始末节点
		private var _startNode:Node;
		private var _endNode:Node;
		//8方向
		private const octahedral:Array = [[ -1, -1], [0, -1], [1, -1], [ -1, 0], [1, 0], [ -1, 1], [0, 1], [1, 1]];
		
		//介入网格
		public function Astar(grid:Grid = null) 
		{
			_grid = grid;
		}
		
		public function set grid(grid:Grid):void
		{
			_grid = grid;
		}
		
		public function get grid():Grid
		{
			return _grid;
		}
		
		public function startTo(x:int = 0, y:int = 0):Boolean
		{
			_startNode = _grid.getNode(x, y);
			_open = new Array;
			_path = new Array;
			_closed = new Array;
			return _startNode.isWalk();
		}
		
		public function endTo(x:int=0,y:int=0):Boolean
		{
			_endNode = _grid.getNode(x, y);
			if (null == _endNode) return false;
			return _endNode.isWalk();
		}
		
		//结束节点不存在的时候选择接近点
		/*
		public function findBeeLine(dps:Node):Node
		{
			var starttime:int = getTimer();
			var node:Node = dps;
			var test:Node;
			var length:int = 1;
			while (!node.isWalk()) {
				if (getTimer() - starttime > _MAX_ELAPSED_TIME_ / 2) {
					trace("无法早到最近点，超时->1.5秒");
					return _startNode;
				}
				for (var i:int = 0; i < octahedral.length; i++ ) 
				{
					var dx:int = node.x + octahedral[i][0];
					var dy:int = node.y + octahedral[i][1];
					test = _grid.getNode(dx, dy);
				}
			}	
			return null;
		}*/
		
		public function seach():Boolean
		{
			var node:Node = _startNode;
			var starttime:int = getTimer();
			var test:Node;
			if (null == _endNode || !_endNode.isWalk()) {
				trace("目标节点不可行！");
				return false;
			}
			while (node != _endNode)
			{
				if (getTimer() - starttime > _MAX_ELAPSED_TIME_) {
					trace("寻路超时->" + _MAX_ELAPSED_TIME_);
					return false;
				}
				//估算
				for (var i:int = 0; i < octahedral.length; i++ ) 
				{
					var dx:int = node.x + octahedral[i][0];
					var dy:int = node.y + octahedral[i][1];
					test = _grid.getNode(dx, dy);
					//是否为当前节点？是否可行？ 这里判断了拐角,冒失效率低了4被左右
					//if (test == null || test == node || !test.isWalk()) continue;
					if (test == null || test == node || !test.isWalk() || isCanCorner(node, test)) continue;
					//
					var cost:Number = _straightCost; 
                        //如果是对象线，则使用对角代价
                    if (!((node.x == test.x) || (node.y == test.y))) cost = _diagCost;
					
                    //计算test节点的总代价                      
                    var g:Number = node.g + cost * test.costMultiplier;
                    var h:Number = _handle(test);                   
                    var f:Number = g + h;
					
					if (isOpen(test) || isClosed(test)){
                        if (f < test.f) test.f = f,test.g = g,test.h = h,test.parent = node;
                    }else{
                        test.f = f,test.g = g,test.h = h,test.parent = node;
                        _open.push(test);
                    }
				}//for end
				
				_closed.push(node);
				
                if (_open.length == 0)
                {
                    trace("没找到最佳节点，无路可走!");
                    return false;
                }
				
                _open.sortOn("f", Array.NUMERIC);
                node=_open.shift() as Node;
            }//while end
			
			buildPath();
			trace("寻路消耗时间：", getTimer() - starttime);
			return true;
		}
		
		private function isCanCorner(node:Node,test:Node):Boolean
		{
			var corner:Node = _grid.getNode(node.x, test.y);
			if (corner == null || !corner.isWalk()) return true;
			corner = _grid.getNode(test.x, node.y);
			if (corner == null || !corner.isWalk()) return true;
			return false;
		}
		
		private function buildPath():void
        {
			 var node:Node=_endNode;
            _path = new Array();
            _path.push(node);
            while (node != _startNode)
            {
                node=node.parent;
                _path.unshift(node);
            }	
        }
		
		//最终的路径
		public function get path():Array
		{
			return _path;
		}
		
		//开放列表
		public function get open():Array
		{
			return _open;
		}
		
		public function isOpen(node:Node):Boolean
		{
			for (var i:int = 0; i < _open.length; i++ ) {
				if (_open[i] == node) return true;
			}
			return false;
		}
		
		private function isClosed(node:Node):Boolean
		{
			for(var i:int = 0; i < _closed.length; i++)
			{
				if(_closed[i] == node)
				{
					return true;
				}
			}
			return false;
		}
		
		//曼哈顿估价法
        protected function manhattan(node:Node):Number
        {
            return Math.abs(node.x - _endNode.x) * _straightCost + Math.abs(node.y - _endNode.y) * _straightCost;
        }
 
        //几何估价法
        protected function euclidian(node:Node):Number
        {
            var dx:Number=node.x - _endNode.x;
            var dy:Number=node.y - _endNode.y;
            return Math.sqrt(dx * dx + dy * dy) * _straightCost;
        }
 
        //对角线估价法
        protected function diagonal(node:Node):Number
        {
            var dx:Number=Math.abs(node.x - _endNode.x);
            var dy:Number=Math.abs(node.y - _endNode.y);
            var diag:Number=Math.min(dx, dy);
            var straight:Number=dx + dy;
            return _diagCost * diag + _straightCost * (straight - 2 * diag);
        }
		//ends
	}
}