package game.ui.map 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import game.consts.LayerType;
	import game.consts.NoticeDefined;
	import game.datas.obj.PlayerObj;
	import game.datas.vo.ActionVo;
	import game.logic.WorldKidnap;
	import game.ui.map.RoleSprite;
	import org.alg.astar.Astar;
	import org.alg.astar.Node;
	import org.alg.map.MapBase;
	import org.alg.map.MeshMap;
	import org.alg.utils.FormatUtils;
	import org.web.sdk.FrameWork;
	import org.web.sdk.net.socket.ServerSocket;
	import org.web.sdk.system.GlobalMessage;
	import org.web.sdk.system.key.KeyAction;
	import org.web.sdk.system.key.KeyManager;
	import org.web.sdk.tool.Clock;
	import org.web.sdk.utils.ArrayUtils;
	import org.web.sdk.utils.HashMap;
	
	public class WorldMap
	{
		private static var _ins:WorldMap;
		
		public static function gets():WorldMap
		{
			if (null == _ins) _ins = new WorldMap;
			return _ins;
		}
		
		//
		private const STOP_TIME:int = 3000;
		private var sendTime:Number = 0;
		//主演
		public var actor:RoleSprite;
		//所有角色
		public var playerHash:HashMap;
		private var isListener:Boolean = false;
		
		private var map:MeshMap;
		
		public function WorldMap() 
		{
			playerHash = new HashMap;
		}
		
		private function initialization():void
		{
			if (isListener) return;
			isListener = true;
			FrameWork.stage.addEventListener(Event.ENTER_FRAME, onEnter);
			FrameWork.stage.addEventListener(Event.RESIZE, onResize);
			FrameWork.stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		public function getMap():MeshMap
		{
			return map;
		}
		
		public function free():void
		{
			if (map) map.hide();
			if (!isListener) return;
			isListener = false;
			FrameWork.stage.removeEventListener(Event.ENTER_FRAME, onEnter);
			FrameWork.stage.removeEventListener(Event.RESIZE, onResize);
			FrameWork.stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		}
			
		private function onResize(e:Event):void
		{
			map.followDisplay(actor);
		}
		
		//显示地图
		public function showMap(id:uint):void
		{
			free();
			playerHash.clear();
			MapBase.showMap(id, complete);
		}
		
		//添加到地图
		private function complete(e:MeshMap):void
		{
			initialization();
			WorldKidnap.addToLayer(this.map = e, LayerType.MAP);
			//添加主角
			setActor(PlayerObj.gets());
		}
		
		private function onStageClick(e:MouseEvent):void 
		{
			var astar:Astar = new Astar(this.map.grid);
			var dx:int = actor.x / map.grid.nodeWidth;
			var dy:int = actor.y / map.grid.nodeHeight;
			astar.startTo(dx, dy);
			dx = this.map.mouseX / map.grid.nodeWidth;
			dy = this.map.mouseY / map.grid.nodeHeight;
			astar.endTo(dx, dy);
			//确定第一个方向
			if (astar.seach()) {
				actor.setPath(astar.path);
				actor.fetch();	//到达下一个点
			}else {
				actor.setPath(null);
			}
		}
		
		private function onEnter(e:Event = null):void
		{
			if (map.isshow()) {
				render();
				actor.render();
				//空闲3秒发送一次自己的坐标
				if (actor.isWait()) {
					if (getTimer() - sendTime>STOP_TIME) {
						ServerSocket.socket.sendNotice(NoticeDefined.STAND_HERE);
						sendTime = getTimer();
					}
				}else {
					map.followDisplay(actor);
					sendSelf();
				}
			}
		}
		
		//添加主角
		private function setActor(data:PlayerObj):void
		{
			if (actor) actor.hide();
			actor = new RoleSprite(map.grid, data);
			//actor.addEventListener("move", sendSelf, false, 0, true);
			actor.moveTo(data.x, data.y);
			addChind(actor);
			map.followDisplay(actor);
		}
		
		//测试调用
		private function test():void
		{
			var player:PlayerObj;
			var dx:Number;
			var dy:Number;
			for (var i:int = 0; i < 800; i++) {
				player = new PlayerObj;
				dx = Math.random() * 450 + (actor.x - 250);
				dy = Math.random() * 400 + (actor.y - 200);
				player.update(i, "测试" + i, dx, dy);
				stop(player);
			}
		}
		
		public function sendSelf(e:Object = null):void
		{
			ActionVo.gets().setData(actor.point, actor.x, actor.y, map.getMapRect(actor.x, actor.y), 50, 100);
			ServerSocket.socket.sendNotice(NoticeDefined.USER_MOVE, ActionVo.gets());
		}
		
		//建立角色
		public function createPlayer(data:PlayerObj):RoleSprite
		{
			var key:String = data.uid.toString();
			var player:RoleSprite = playerHash.getValue(key);
			if (player == null) {
				player = new RoleSprite(map.grid,data);
				playerHash.put(key, player);
				player.stand();
				addChind(player);
			}
			player.update(data);
			return player;
		}
		
		public function stop(data:PlayerObj):void
		{
			var player:RoleSprite = createPlayer(data);
			player.moveTo(data.x, data.y);
			player.stand(data.point);
		}
		
		public function move(data:PlayerObj):void
		{
			var player:RoleSprite = createPlayer(data);
			player.moveTo(data.x, data.y);
			player.move(data.point);
		}
		
		//移除角色
		public function removeUser(uid:int):void
		{
			var key:String = uid.toString();
			var player:RoleSprite = playerHash.remove(key);
			if (player) player.hide();
		}
		
		public function addChind(dis:DisplayObject):void
		{
			if (dis == null) return;
			if (map) map.actionLayer.addChild(dis);
		}
		
		//每帧都渲染用户
		private function render():void
		{
			if (null == map) return;
			var time:int = getTimer();
			var userRoot:Sprite = map.actionLayer;
			var rect:Rectangle = map.getVisibility(0,100);
			var list:Array = [];
			var player:RoleSprite;
			var index:int = userRoot.numChildren - 1;
			for (; index >= 0; index--)
			{
				player = userRoot.getChildAt(index) as RoleSprite;
				if (player == null) continue;
				if (rect.contains(player.x, player.y)) list.push(player);
				else removeUser(player.getUid());
				//if (!player.isself()) player.render();
			}
			//排序，TM比写的排序算法快的多
			list.sortOn("y", Array.NUMERIC);
			var floor:int = 0;
			for (index = 0; index < list.length; index++) {
				player = list[index];
				floor = index;
				if (floor >= userRoot.numChildren) floor = userRoot.numChildren - 1;
				userRoot.setChildIndex(player, floor);
			}
			trace("渲染时间：", getTimer() - time);
		}
		
		//ends
	}

}