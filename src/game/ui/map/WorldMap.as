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
	import game.datas.obj.ActionObj;
	import game.datas.obj.PlayerObj;
	import game.datas.vo.ActionVo;
	import game.logic.WorldKidnap;
	import game.ui.map.RoleSprite;
	import org.web.rpg.astar.Astar;
	import org.web.rpg.astar.Node;
	import org.web.rpg.core.MeshMap;
	import org.web.rpg.core.MapData;
	import org.web.rpg.utils.MapPath;
	import org.web.sdk.Mentor;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.net.socket.ServerSocket;
	import org.web.sdk.tool.Clock;
	import org.web.sdk.utils.HashMap;
	
	public class WorldMap
	{
		//
		private const STOP_TIME:int = 3000;
		private var sendTime:Number = 0;
		//主演
		public var actor:RoleSprite;
		//所有角色
		public var playerHash:HashMap;
		//
		private var isListener:Boolean = false;
		
		private var map:MeshMap;
		
		public function WorldMap() 
		{
			playerHash = new HashMap;
			map = new MeshMap;
		}
		
		private function initialization():void
		{
			if (isListener) return;
			isListener = true;
			Mentor.stage.addEventListener(Event.ENTER_FRAME, onEnter);
			Mentor.stage.addEventListener(Event.RESIZE, onResize);
			Mentor.stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		public function getMap():MeshMap
		{
			return map;
		}
		
		public function free():void
		{
			map.removeFromFather();
			playerHash.clear();
			if (!isListener) return;
			isListener = false;
			Mentor.stage.removeEventListener(Event.ENTER_FRAME, onEnter);
			Mentor.stage.removeEventListener(Event.RESIZE, onResize);
			Mentor.stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		}
			
		private function onResize(e:Event):void
		{
			map.followDisplay(actor);
		}
		
		//显示地图
		public function showMap(id:uint):void
		{
			free();
			Mentor.downLoad(MapPath.getMapConfig(id), LoadEvent.TXT, complete);
		}
		
		private function complete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) return;
			map.setMapdata(MapData.create(new XML(e.target as String)));
			if(!map.isAdded()) WorldKidnap.addToLayer(map, LayerType.MAP);
			//添加主角
			setActor(PlayerObj.gets());
			//初始化
			initialization();
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
			}else {
				actor.setPath(null);
			}
		}
		
		private function onEnter(e:Event = null):void
		{
			if (map.isAdded()) {
				render();
				//actor.render();
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
			if (actor) actor.removeFromFather();
			actor = new RoleSprite(map.grid, data);
			//actor.addEventListener("move", sendSelf, false, 0, true);
			actor.moveTo(data.x, data.y);
			addChind(actor);
			map.followDisplay(actor);
			//
			playerHash.put(data.uid.toString(), actor);
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
		
		public function action(data:ActionObj):void
		{
			var player:RoleSprite = playerHash.getValue(data.uid.toString());
			if (player) {
				player.attack(data.point);
			}
		}
		
		//移除角色
		public function removeUser(uid:int):void
		{
			var key:String = uid.toString();
			var player:RoleSprite = playerHash.remove(key);
			if (player) player.removeFromFather();
		}
		
		public function addChind(dis:DisplayObject):void
		{
			if (dis == null) return;
			if (map) map.actionLayer.addChild(dis);
		}
		
		//每帧都渲染用户  这里可以优化，500人左右问题不大
		private function render():void
		{
			if (null == map) return;
			var t1:int = getTimer();
			var userRoot:Sprite = map.actionLayer;
			var rect:Rectangle = map.getVisibility(0,100);
			var list:Array = [];
			var player:RoleSprite;
			var index:int = userRoot.numChildren - 1;
			for (; index >= 0; index--)
			{
				player = userRoot.getChildAt(index) as RoleSprite;
				if (player == null) continue;
				if (rect.contains(player.x, player.y)) {
					list.push(player);
				}else {
					removeUser(player.getUid());
				}
				player.frameRender();
			}
			//trace("一次：", getTimer() - t1);
			if (userRoot.numChildren < 2) return;
			//排序，TM比写的排序算法快的多
			var t2:int = getTimer();
			list.sortOn("y", Array.NUMERIC);
			//trace("二次:", getTimer() - t2);
			var t3:int = getTimer();
			for (index = list.length -1; index >= 0; index--)
			{
				player = list[index];
				userRoot.setChildIndex(player, index);
			}
			//trace("三次:", getTimer() - t3);
			//这里主要是第三次渲染时间太久	
		}
		
		//ends
	}

}