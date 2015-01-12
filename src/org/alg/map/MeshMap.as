package org.alg.map 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import org.alg.astar.Grid;
	import org.alg.astar.Node;
	import org.alg.utils.DrawLine;
	import org.web.sdk.display.KitSprite;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.FrameWork;
	
	/*
	 * 这里作为背景和寻路算法基础
	 * */
	public class MeshMap extends KitSprite 
	{
		//网格
		private var _grid:Grid;
		//
		private var _userLayer:Sprite;
		//
		private var _backdrop:MapShallow;
		
		//构造 不允许改变网格
		public function MeshMap(grid:Grid)
		{
			this._grid = grid;
			this.addEventListener(Event.REMOVED_FROM_STAGE, hideEvent, false, 0, true);
			this.addChild(_userLayer = new Sprite);
			_userLayer.mouseEnabled = false;
		}
		
		override public function hideEvent(event:Event = null):void 
		{
			super.hideEvent(event);
			clearAction();
			_backdrop.dispose();
			if (_backdrop.parent) _backdrop.parent.removeChild(_backdrop);
		}
		
		public function get grid():Grid
		{
			return _grid;
		}
		
		//底图必须是全屏模式
		//桌面，也就是底图
		public function desktop():Sprite
		{
			return _backdrop;
		}
		
		//设置背景地图  主动设置的时候会清桌面所有图标
		public function setDesktop(dis:DisplayObject):void
		{
			_backdrop = dis as MapShallow;
			_backdrop.openLoad = true;
			this.addChildAt(_backdrop, 0);
			//drawGridShape();
		}
		
		//设置地图的一个位置，返回其中心角色的位置
		//设置人物在底图的位置   用于初始化位置
		public function setSceneLocalInMap(px:int, py:int):Point
		{
			var dx:int = px >= 0 ? px : -px;
			var dy:int = py >= 0 ? py : -py;
			var playerx:int = dx > _backdrop.width ? _backdrop.width - 1 : dx;
			var playery:int = dy > _backdrop.height ? _backdrop.height - 1 : dy;
			if (dx > _backdrop.width - FrameWork.winWidth / 2 ) {
				dx = _backdrop.width - FrameWork.winWidth;
			}else {
				dx = ((playerx - FrameWork.winWidth / 2 < 0) ? 0 : playerx - FrameWork.winWidth / 2);
			}
			if (dy > _backdrop.height - FrameWork.winHeight / 2) {
				dy = _backdrop.height - FrameWork.winHeight;
			}else {
				dy = ((playery - FrameWork.winHeight / 2) < 0 ? 0 : playery - FrameWork.winHeight / 2);
			}
			moveTo(-dx, -dy);
			return new Point(playerx, playery);
		}
		
		public function update():void
		{
			_backdrop.setLocation(this.x,this.y);
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
					var rightx:Number = FrameWork.winWidth - this._backdrop.width;
					if (this.x > rightx) this.x = endx < rightx ? rightx : endx;
				}
			}
			if (dy < 0) {
				if (FrameWork.winHeight / 2 >= po.y) {
					if (this.y < 0) this.y = endy > 0 ? 0 : endy; 
				}
			}else {
				if (po.y >= FrameWork.winHeight / 2) {
					var righty:Number = FrameWork.winHeight - this._backdrop.height;
					if (this.y > righty) this.y = endy < righty ? righty : endy;
				}
			}
			//ends
		}
		
		public function get actionLayer():Sprite
		{
			return _userLayer;
		}
		
		public function clearAction():void
		{
			while (_userLayer.numChildren) _userLayer.removeChildAt(0);
		}
		
		//取一个屏幕左边的基点   偏移是为了扩大屏幕
		public function getLeft(localx:int, localy:int):Point
		{
			var lenx:int = FrameWork.winWidth >> 1;
			var leny:int = FrameWork.winHeight >> 1;
			var dx:int = localx - lenx;
			var dy:int = localy - leny;
			var rightx:int = this.width - lenx;
			var righty:int = this.height - leny;
			if (localx > rightx) dx = this.width - FrameWork.winWidth;
			if (localy > righty) dy = this.height - FrameWork.winHeight;
			if (localx < lenx) dx = 0;
			if (localy < leny) dy = 0;
			return new Point(dx, dy);
		}
		
		//一个碰撞
		public function getHitRect(offx:int = 0, offy:int = 0):Rectangle
		{
			var tpo:Point = this.globalToLocal(new Point(FrameWork.leftx, FrameWork.lefty));
			rect.x = tpo.x;
			rect.y = tpo.y;
			rect.width = FrameWork.winWidth + offx;
			rect.height = FrameWork.winHeight + offy;
			return rect;
		}
		
		private static const rect:Rectangle = new Rectangle();
		
		//绘制可视化网格
		public function drawGridShape():void
		{
			_backdrop.addChild(DrawLine.drawGrid(_grid.across, _grid.vertical, _grid.nodeWidth, _grid.nodeHeight));
			_backdrop.addChild(DrawLine.drawRectToNode(_grid));
		}
		//
	}
}