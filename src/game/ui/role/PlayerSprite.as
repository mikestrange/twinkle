package game.ui.role 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import game.consts.NoticeDefined;
	import game.datas.PlayerObj;
	import game.datas.SelfData;
	import game.datas.vo.ActionVo;
	import game.ui.inters.IRole;
	import game.ui.map.WorldMap;
	import game.ui.utils.EditorTexture;
	import org.alg.astar.Grid;
	import org.alg.astar.Node;
	import org.alg.utils.FormatUtils;
	import org.web.sdk.display.core.BoneSprite;
	import org.web.sdk.display.core.TextEditor;
	import org.web.sdk.display.core.Texture;
	import org.web.sdk.display.engine.IStepper;
	import org.web.sdk.display.engine.SunEngine;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.gpu.core.GpuDisplayObject;
	import org.web.sdk.net.socket.ServerSocket;
	
	/*
	 * role
	 * */
	public class PlayerSprite extends BoneSprite implements IRole, IStepper
	{
		private var _action:PlayerAction;
		//
		private var _data:PlayerObj;
		private var _texture:Texture;
		private var speedX:int = 4;
		private var speedY:int = 4;
		private var path:Array;
		private var pathIndex:int = 0;
		private var max_leng:int = speedX + speedY;
		private var grid:Grid;
		private var endpo:Point = new Point;
		private var startpo:Point = new Point;
		private var iswait:Boolean = true;
		
		public function PlayerSprite(grid:Grid, data:PlayerObj) 
		{
			this.grid = grid;
			this._data = data;
			this.addEventListener(Event.ADDED_TO_STAGE, showEvent, false, 0, true);
			this.addEventListener(Event.REMOVED_FROM_STAGE, hideEvent, false, 0, true);
			this.initialization();
		}
		
		override protected function hideEvent(e:Object = null):void 
		{
			this.finality();
		}
		
		override public function initialization():void 
		{
			super.initialization();
			//
			_action = new PlayerAction("playerAction");
			_action.load(_data.url);
			this.addChild(_action);
			//名称
			_texture = new Texture(EditorTexture.draw(_data.usn));
			this.addChild(_texture);
			//绘制一个基点
			drawSingularity();
			//
			this.run();
		}
		
		public function drawSingularity(high:int = 0):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xcccccc,.3);
			this.graphics.drawEllipse(-20, -12, 40, 16);
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
					if (_data.isSelf()) this.dispatchEvent(new Event("move"));
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
			_action.setActionAndPoint(ActionType.ATTACK, value);
		}
		
		public function walk(value:int = -1):void
		{
			_action.setActionAndPoint(ActionType.WALK, value);
		}
		
		public function hit(value:int = -1):void
		{
			_action.setActionAndPoint(ActionType.HIT, value);
		}
		
		
		/* INTERFACE org.web.sdk.display.engine.IStepper */
		public function run():void 
		{
			SunEngine.run(this);
		}
		
		public function step(event:Object):void 
		{
			_action.render();
			_action.moveTo( -_action.width >> 1, -_action.height);
			_texture.x = -_texture.width >> 1;
			_texture.y = -_action.height - _texture.height;
		}
		
		public function die():void 
		{
			SunEngine.cut(this);
		}
		
		//ends
	}

}