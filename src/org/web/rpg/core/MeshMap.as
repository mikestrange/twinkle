package org.web.rpg.core 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.web.rpg.astar.Grid;
	import org.web.rpg.core.MapData;
	import org.web.rpg.utils.GridLine;
	import org.web.rpg.astar.Node;
	import org.web.sdk.display.core.ActiveSprite;
	import org.web.sdk.Mentor;
	/*
	 * 这里作为背景和寻路算法基础
	 * */
	public class MeshMap extends ActiveSprite 
	{
		//地图数据
		private var _mapdata:MapData;
		//网格
		private var _grid:Grid;
		//Npc,角色,物件
		private var _itemLayer:ActiveSprite;
		//分快加载的地方
		private var _backdrop:MapShallow;
		
		//构造 不允许改变网格
		public function MeshMap()
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, hideEvent, false, 0, true);
			this.addChild(_itemLayer = new ActiveSprite);
			_itemLayer.lockMouse();
		}
		
		//设置所有数据
		public function setMapdata(data:MapData):void
		{
			hideEvent();
			_mapdata = data;
			_grid = Grid.createByArray(data.mapArr, data.across, data.vertical, data.sizeWidth, data.sizeHeight);
			_backdrop = new MapShallow(data);
			this.addChildAt(_backdrop, 0);
		}
		
		override protected function hideEvent():void 
		{
			super.hideEvent();
			_itemLayer.clearChildren();
			removeDesktop();
		}
		
		public function get grid():Grid
		{
			return _grid;
		}
		
		public function get mapData():MapData
		{
			return _mapdata;
		}
		
		//桌面，也就是底图
		public function desktop():Sprite
		{
			return _backdrop;
		}
		
		public function removeDesktop():void
		{
			if (_backdrop) {
				_backdrop.removeFromFather();
				_backdrop = null;
			}
		}
		
		public function update():void
		{
			if (_backdrop) _backdrop.setLocation(this.x,this.y);
		}
		
		//设置地图的一个位置，返回其中心角色的位置
		//设置人物在底图的位置   用于初始化位置
		public function setSceneLocalInMap(px:int, py:int):Point
		{
			var dx:int = px >= 0 ? px : -px;
			var dy:int = py >= 0 ? py : -py;
			var playerx:int = dx > _mapdata.M_width ? _mapdata.M_width - 1 : dx;
			var playery:int = dy > _mapdata.M_height ? _mapdata.M_height - 1 : dy;
			if (dx > _mapdata.M_width - Mentor.winWidth / 2 ) {
				dx = _mapdata.M_width - Mentor.winWidth;
			}else {
				dx = ((playerx - Mentor.winWidth / 2 < 0) ? 0 : playerx - Mentor.winWidth / 2);
			}
			if (dy > _mapdata.M_height - Mentor.winHeight / 2) {
				dy = _mapdata.M_height - Mentor.winHeight;
			}else {
				dy = ((playery - Mentor.winHeight / 2) < 0 ? 0 : playery - Mentor.winHeight / 2);
			}
			moveTo(-dx, -dy);
			return new Point(playerx, playery);
		}
		
		//跟随主演
		public function followDisplay(dis:DisplayObject):void
		{
			setSceneLocalInMap(dis.x, dis.y);
			update();
		}
		
		//地图跟随移动
		public function followMove(dx:Number, dy:Number, po:Point):void
		{
			var endx:int = (this.x - dx) | 0;
			var endy:int = (this.y - dy) | 0;
			//是否在舞台中央
			//var po:Point = $player.parent.localToGlobal(new Point($player.x, $player.y));
			if (dx < 0) {
				if (Mentor.winWidth / 2 >= po.x) {
					if (this.x < 0) this.x = endx > 0 ? 0 : endx;
				}
			}else {
				if (po.x >= Mentor.winWidth / 2) {
					var rightx:Number = Mentor.winWidth - _mapdata.M_width;
					if (this.x > rightx) this.x = endx < rightx ? rightx : endx;
				}
			}
			if (dy < 0) {
				if (Mentor.winHeight / 2 >= po.y) {
					if (this.y < 0) this.y = endy > 0 ? 0 : endy; 
				}
			}else {
				if (po.y >= Mentor.winHeight / 2) {
					var righty:Number = Mentor.winHeight - _mapdata.M_height;
					if (this.y > righty) this.y = endy < righty ? righty : endy;
				}
			}
			//ends
		}
		
		public function get actionLayer():Sprite
		{
			return _itemLayer;
		}
		
		//取一个屏幕左边的基点   偏移是为了扩大屏幕
		public function getMapRect(localx:int, localy:int):Rectangle
		{
			var lenx:int = Mentor.winWidth >> 1;
			var leny:int = Mentor.winHeight >> 1;
			var dx:int = localx - lenx;
			var dy:int = localy - leny;
			var rightx:int = this.width - lenx;
			var righty:int = this.height - leny;
			currRect.width = Mentor.winWidth;
			currRect.height = Mentor.winHeight;
			if (localx > rightx) currRect.x = this.width - Mentor.winWidth;
			if (localy > righty) currRect.y = this.height - Mentor.winHeight;
			if (localx < lenx) currRect.x = 0;
			if (localy < leny) currRect.y = 0;
			return currRect;
		}
		
		//当前地图的显示范围
		public function getVisibility(offx:int = 0, offy:int = 0):Rectangle
		{
			var tpo:Point = this.globalToLocal(new Point(Mentor.leftx, Mentor.lefty));
			rect.x = tpo.x;
			rect.y = tpo.y;
			rect.width = Mentor.winWidth + offx;
			rect.height = Mentor.winHeight + offy;
			return rect;
		}
		
		private static const rect:Rectangle = new Rectangle();
		private static const currRect:Rectangle = new Rectangle();
		//
	}
}