package game.ui.map 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import game.consts.NoticeDefined;
	import game.datas.obj.PlayerObj;
	import game.datas.SelfData;
	import game.datas.vo.ActionVo;
	import game.ui.core.ActionType;
	import game.ui.core.GpuCustom;
	import game.inters.IRole;
	import game.ui.map.WorldMap;
	import game.utils.DrawUtils;
	import org.alg.astar.Grid;
	import org.alg.astar.Node;
	import org.alg.utils.FormatUtils;
	import org.web.sdk.display.engine.Steper;
	import org.web.sdk.display.KitSprite;
	import org.web.sdk.display.TextEditor;
	import org.web.sdk.gpu.VRayMap;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.SunEngine;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.gpu.GpuSprite;
	import org.web.sdk.net.socket.ServerSocket;
	
	/*
	 * role
	 * */
	public class RoleSprite extends KitSprite implements IRole
	{
		private var _action:GpuCustom;
		//
		private var _data:PlayerObj;
		private var _texture:VRayMap;
		private var speedX:int = 10;
		private var speedY:int = 10;
		private var path:Array;
		private var pathIndex:int = 0;
		private var max_leng:int = speedX + speedY;
		private var grid:Grid;
		private var endpo:Point = new Point;
		private var startpo:Point = new Point;
		private var iswait:Boolean = true;
		
		public function RoleSprite(grid:Grid, data:PlayerObj) 
		{
			this.grid = grid;
			this._data = data;
			Multiple.addListener(this);
			this.initialization();
		}
		
		override public function hideEvent(event:Event = null):void 
		{
			super.hideEvent(event);
			this.finality();
		}
		
		override public function initialization(value:Boolean = true):void 
		{
			_action = new GpuCustom("playerAction", 4, ActionType.STAND);
			_action.play();
			var matrix:Matrix = new Matrix;
			matrix.translate( -20, -90)
			_action.transform.matrix = matrix;
			this.addChild(_action);
			//名称
			_texture = new VRayMap(DrawUtils.draw(_data.usn));
			_texture.x = -_texture.width >> 1;
			_texture.y = -90 - _texture.height;
			this.addChild(_texture);
			//
			stand();
			/*
			this.graphics.clear();
			this.graphics.beginFill(0xff0000);
			this.graphics.drawCircle( -1, -1, 2);
			this.graphics.endFill();
			*/
		}
		
		public function setPath(value:Array):void
		{
			path = value;
			pathIndex = 1;
			iswait = (path == null);
		}
		
		override public function render():void 
		{
			if (path) {
				var node:Node = path[pathIndex];
				if (node == null) {
					path = null;
					return;
				}
				doplace(node);
				if (Point.distance(endpo, startpo) < max_leng) {
					if (_data.isself()) this.dispatchEvent(new Event("move"));
					pathIndex++;
					fetch();
					if (pathIndex >= path.length) {
						this.stand();
						path = null;
						iswait = true;
					}
				}else {
					this.x += (endpo.x - this.x) / speedX;
					this.y += (endpo.y - this.y) / speedY;
				}
			}
		}
		
		//平添
		private function doplace(node:Node):void
		{
			endpo.x = node.x * grid.nodeWidth + (grid.nodeWidth >> 1);
			endpo.y = node.y * grid.nodeHeight + (grid.nodeHeight >> 1);
			startpo.x = this.x;
			startpo.y = this.y;
		}
		
		//确定方位，注入移动  --自己猜可以用
		public function fetch():void
		{
			var node:Node = path[pathIndex];
			if (node == null) return;
			doplace(node);
			var point:int = FormatUtils.getPoint(endpo, startpo);
			this.move(point);
		}
		
		public function getUid():int
		{
			return _data.uid;
		}
		
		public function isself():Boolean
		{
			return _data.uid == SelfData.gets().uid;
		}
		
		public function get point():int
		{
			return _action.getPoint();
		}
		
		//刷新数据
		public function update(data:PlayerObj):void
		{
			_data = data;
		}
		
		public function isWait():Boolean
		{
			return iswait;
		}
		
		//一系列动作
		public function move(value:int = -1):void
		{
			_action.setActionAndPoint(ActionType.RUN, value);
		}
		
		public function stand(value:int = -1):void
		{
			_action.setActionAndPoint(ActionType.STAND, value);
		}
		
		public function attack(value:int = -1):void
		{
			_action.setActionAndPoint(ActionType.YEMAN, value);
			//_action.setActionAndPoint(ActionType.BEATEN, value, 1);
			//_action.setActionAndPoint(ActionType.ATTACK, value);
		}
		
		public function walk(value:int = -1):void
		{
			_action.setActionAndPoint(ActionType.WALK, value);
		}
		
		public function hit(value:int = -1):void
		{
			_action.setActionAndPoint(ActionType.HIT, value);
		}
		
		//ends
	}

}