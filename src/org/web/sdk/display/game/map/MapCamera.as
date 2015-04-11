package org.web.sdk.display.game.map 
{
	import com.greensock.TweenLite;
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
			if (_limit) {
				LimitX(x);
			}else {
				_lookx = x;
			}
		}
		
		public function set looky(y:int):void
		{
			if (_looky == y) return;
			if (_limit) {
				LimitY(y);
			}else {
				_looky = y;
			}
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
			TweenLite.killTweensOf(_root);
			TweenLite.to(_root, 5, { x: -_lookx, y: -_looky });
			//_root.moveTo(-_lookx, -_looky);
			_root.setRenderPosition(_lookx, _looky);
		}
		
		//----限制设置
		//设置一个限制,一旦限制的时候，每次设置都指向中心点
		public function setLimit(value:Boolean):void
		{
			_limit = value;
		}
		
		public function LimitX(x:int):void
		{
			const min:int = 0;
			const max:int = _root.limitWidth - AppWork.winWidth;
			_lookx = x - (AppWork.winWidth >> 1);
			if (_lookx <= min) _lookx = min;
			if (_lookx >= max) _lookx = max;
		}
		
		public function LimitY(y:int):void
		{
			_looky = y - (AppWork.winHeight >> 1);
			const min:int = 0;
			const max:int = _root.limitHeight - AppWork.winHeight;
			//
			if (_looky <= min) _looky = min;
			if (_looky >= max) _looky = max;
		}
		
		//ends
	}

}