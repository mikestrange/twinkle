package org.web.sdk.display.game.map 
{
	import org.web.sdk.AppWork;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 地图摄像头
	 */
	public class MapCamera 
	{
		private var _lookx:int;
		private var _looky:int;
		private var _root:LandSprite;
		private var _limit:Boolean = true;
		
		public function setMap(map:LandSprite):void
		{
			_root = map;
		}
		
		public function getView():LandSprite
		{
			return _root;
		}
		
		public function get lookx():int
		{
			return _lookx;
		}
		
		public function get looky():int
		{
			return _looky;
		}
		
		//观测一个点
		public function set lookx(x:int):void
		{
			if (_lookx == x) return;
			_lookx = x;
			if (_limit) LimitX();
			_root.x = -_lookx;
		}
		
		public function set looky(y:int):void
		{
			if (_looky == y) return;
			_looky = y;
			if (_limit) LimitY();
			_root.y = -_looky;
		}
		
		//返回当前点
		public function lookTo(x:int, y:int):void
		{
			this.lookx = x;
			this.looky = y;
		}
		
		//偏移
		public function lookOffset(offx:int,offy:int):void
		{
			lookTo(_lookx + offx, _looky + offy);
		}
		
		//刷新缓冲和地图位置
		public function updateBuffer():void
		{
			_root.setRenderPosition(_lookx, _looky);
		}
		
		//----限制设置
		//设置一个限制,一旦限制的时候，地图就不能移出一个范围
		public function setLimit(value:Boolean):void
		{
			_limit = value;
		}
		
		//这个时候为中心点
		public function LimitX():void
		{
			_lookx -= AppWork.winWidth / 2;
			//
			var min:int = 0;
			var max:int = _root.limitWidth - AppWork.winWidth;
			//
			if (_lookx <= min) _lookx = 0;
			//
			if (_lookx >= max) _lookx = max;
		}
		
		public function LimitY():void
		{
			_looky -= AppWork.winHeight / 2;
			var min:int = 0;
			var max:int = _root.limitHeight - AppWork.winHeight;
			//
			if (_looky >= max) _looky = max;
			//
			if (_looky < min) _looky =  0;
		}
		
		//ends
	}

}