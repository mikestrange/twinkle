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
	import org.web.rpg.utils.DrawLine;
	import org.web.rpg.astar.Node;
	import org.web.sdk.display.RawSprite;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.FrameWork;
	/*
	 * 这里作为背景和寻路算法基础
	 * */
	public class MeshMap extends RawSprite 
	{
		//地图数据
		private var _mapdata:MapData;
		//网格
		private var _grid:Grid;
		//Npc,角色,物件
		private var _itemLayer:RawSprite;
		//分快加载的地方
		private var _backdrop:MapShallow;
		
		//构造 不允许改变网格
		public function MeshMap()
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, hideEvent, false, 0, true);
			this.addChild(_itemLayer = new RawSprite);
			_itemLayer.lock();
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
		
		override public function hideEvent(event:Event = null):void 
		{
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
			if (dx > _mapdata.M_width - FrameWork.winWidth / 2 ) {
				dx = _mapdata.M_width - FrameWork.winWidth;
			}else {
				dx = ((playerx - FrameWork.winWidth / 2 < 0) ? 0 : playerx - FrameWork.winWidth / 2);
			}
			if (dy > _mapdata.M_height - FrameWork.winHeight / 2) {
				dy = _mapdata.M_height - FrameWork.winHeight;
			}else {
				dy = ((playery - FrameWork.winHeight / 2) < 0 ? 0 : playery - FrameWork.winHeight / 2);
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
				if (FrameWork.winWidth / 2 >= po.x) {
					if (this.x < 0) this.x = endx > 0 ? 0 : endx;
				}
			}else {
				if (po.x >= FrameWork.winWidth / 2) {
					var rightx:Number = FrameWork.winWidth - _mapdata.M_width;
					if (this.x > rightx) this.x = endx < rightx ? rightx : endx;
				}
			}
			if (dy < 0) {
				if (FrameWork.winHeight / 2 >= po.y) {
					if (this.y < 0) this.y = endy > 0 ? 0 : endy; 
				}
			}else {
				if (po.y >= FrameWork.winHeight / 2) {
					var righty:Number = FrameWork.winHeight - _mapdata.M_height;
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
			var lenx:int = FrameWork.winWidth >> 1;
			var leny:int = FrameWork.winHeight >> 1;
			var dx:int = localx - lenx;
			var dy:int = localy - leny;
			var rightx:int = this.width - lenx;
			var righty:int = this.height - leny;
			currRect.width = FrameWork.winWidth;
			currRect.height = FrameWork.winHeight;
			if (localx > rightx) currRect.x = this.width - FrameWork.winWidth;
			if (localy > righty) currRect.y = this.height - FrameWork.winHeight;
			if (localx < lenx) currRect.x = 0;
			if (localy < leny) currRect.y = 0;
			return currRect;
		}
		
		//当前地图的显示范围
		public function getVisibility(offx:int = 0, offy:int = 0):Rectangle
		{
			var tpo:Point = this.globalToLocal(new Point(FrameWork.leftx, FrameWork.lefty));
			rect.x = tpo.x;
			rect.y = tpo.y;
			rect.width = FrameWork.winWidth + offx;
			rect.height = FrameWork.winHeight + offy;
			return rect;
		}
		
		private static const rect:Rectangle = new Rectangle();
		private static const currRect:Rectangle = new Rectangle();
		//
	}
}