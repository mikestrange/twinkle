package game.ui.map 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import game.datas.obj.PlayerObj;
	import game.datas.SelfData;
	import game.datas.vo.ActionVo;
	import game.ui.core.ActionType;
	import game.ui.interfaces.IRole;
	import game.ui.core.RangeMotion;
	
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.inters.IDisplay;
	import org.web.sdk.display.utils.DrawUtils;
	import org.web.rpg.astar.Grid;
	import org.web.rpg.astar.Node;
	import org.web.rpg.utils.GridLine;
	import org.web.rpg.utils.FormatUtils;
	import org.web.sdk.display.engine.Steper;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.AtomicEngine;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.net.socket.ServerSocket;
	import org.web.sdk.global.maths;
	/*
	 * role
	 * */
	public class RoleSprite extends BaseSprite implements IRole
	{
		private var _action:RangeMotion;
		//
		private var _data:PlayerObj;
		private var _texture:RayDisplayer;
		private var speedX:int = 4;
		private var speedY:int = 2;
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
			super();
		}
		
		override protected function hideEvent():void 
		{
			finality();
		}
		
		override protected function initialization():void 
		{
			_action = new RangeMotion(0, ActionType.STAND, 4);
			_action.setEnder(ActionType.STAND);
			var matrix:Matrix = new Matrix;
			matrix.translate( -20, -90)
			_action.transform.matrix = matrix;
			this.addDisplay(_action);
			//名称
			_texture = new RayDisplayer(DrawUtils.drawEditor(_data.usn));
			_texture.x = -_texture.width >> 1;
			_texture.y = -90 - _texture.height;
			this.addDisplay(_texture);
			//
			stand();
			//DrawLine.drawSkeletonLine(this.graphics);
		}
		
		public function setPath(value:Array):void
		{
			path = value;
			pathIndex = 1;
			iswait = (path == null);
		}
		
		override public function frameRender(float:int = 0):void 
		{
			if (path) {
				if (pathIndex >= path.length) {
					path = null;
					return;
				}
				var node:Node = path[pathIndex];
				var endPos:Point = new Point;
				endPos.x = node.x * grid.nodeWidth + (grid.nodeWidth >> 1);
				endPos.y = node.y * grid.nodeHeight + (grid.nodeHeight >> 1);
				var angle:Number = maths.atanAngle(this.x, this.y, endPos.x, endPos.y);	//计算两点之间的角度
				var mpo:Point = maths.resultant(angle, speedX, speedY);										//计算增量
				this.x -= mpo.x;
				this.y -= mpo.y;
				//
				var point:int = FormatUtils.getIndexByAngle(maths.roundAngle(angle));
				this.move(point);
				//两点之间的长度
				if (maths.distance(this.x, this.y, endPos.x, endPos.y) <= speedX + speedY) {
					this.moveTo(endPos.x, endPos.y);
					pathIndex++;
					if (pathIndex >= path.length) this.stand();
				}
			}
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
			return _action.point;
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
			_action.doAction(ActionType.RUN, value);
		}
		
		public function stand(value:int = -1):void
		{
			_action.doAction(ActionType.STAND, value);
		}
		
		public function attack(value:int = -1):void
		{
			_action.doAction(ActionType.YEMAN, value);
			//_action.setActionAndPoint(ActionType.BEATEN, value, 1);
			//_action.setActionAndPoint(ActionType.ATTACK, value);
		}
		
		public function walk(value:int = -1):void
		{
			_action.doAction(ActionType.WALK, value);
		}
		
		public function hit(value:int = -1):void
		{
			_action.doAction(ActionType.HIT, value);
		}
		
		//ends
	}

}