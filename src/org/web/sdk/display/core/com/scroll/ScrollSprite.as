package org.web.sdk.display.core.com.scroll 
{
	import com.greensock.TweenLite;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import org.web.sdk.AppWork;
	import org.web.sdk.global.UintHash;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.interfaces.IBaseSprite;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 滚动组件
	 */
	public class ScrollSprite extends BaseSprite 
	{
		private static const NONE:int = 0;
		private static const LIMT:int = 200;
		
		//当前状态
		private var _isEnd:Boolean;
		private var _totalSize:int;
		private var _length:int;
		//
		private var _eccentricity:Number = 0.1;	//离心率
		//跟随
		private var _upY:Number;
		private var _downY:Number;
		private var _currentY:Number;
		private var _interval:Number;
		//
		private var _downTime:int;		//按下时间
		private var _tickTime:int;		//按下到松开时间
		//动态
		private var _isDown:Boolean;
		private var _isMove:Boolean;
		//三个必须函数
		private var _rollApply:Function;
		private var _spaceApply:Function;
		private var _lengApply:Function;
		//
		private var _itemMap:UintHash;
		private var _loader:IBaseSprite;
		private var _mask:Shape;
		
		//设置区域
		override public function setLimit(wide:Number = 0, heig:Number = 0):void 
		{
			super.setLimit(wide, heig);
			//建立遮罩
			if (_mask == null) {
				_mask = new Shape;
				this.addChild(_mask);
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,.3);
			_mask.graphics.drawRect(0, 0, wide, heig);
			_mask.graphics.endFill();
			getLoader().mask = _mask;
		}
		
		private function getLoader():IBaseSprite
		{
			if (_loader == null) {
				_loader = new BaseSprite;
				this.addDisplay(_loader);
			}
			return _loader;
		}
		
		override protected function showEvent():void 
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, _onDown);
			AppWork.addStageListener(MouseEvent.MOUSE_MOVE, _onStageMove);
			AppWork.addStageListener(MouseEvent.MOUSE_UP, _onStageUp);
		}
		
		override protected function hideEvent():void 
		{
			super.hideEvent();
			this.removeEventListener(MouseEvent.MOUSE_DOWN, _onDown);
			AppWork.removeStageListener(MouseEvent.MOUSE_MOVE, _onStageMove);
			AppWork.removeStageListener(MouseEvent.MOUSE_UP, _onStageUp);
			_isMove = _isDown = false;
			_interval = _upY = _downY = NONE;
			_downTime = _tickTime = NONE;
		}
		
		private function _onDown(e:MouseEvent):void
		{
			_isDown = true;
			_downTime = getTimer();
			_currentY = _downY = AppWork.stage.mouseY;
		}
		
		private function _onStageUp(e:MouseEvent):void
		{
			_isDown = false;
			_tickTime = getTimer() - _downTime;
			_upY = AppWork.stage.mouseY;
			_currentY = 0;
			_interval = Math.abs(_upY - _downY);
			_isMove = _interval < 5;
			if (_tickTime < LIMT) {
				trace(" tick:", _tickTime, _interval);
			}
			//底部回弹
			if (_isEnd ) {
				if (_totalSize - limitHeight > NONE) {
					tweenLite(limitHeight - _totalSize);
				}else {
					tweenLite(NONE);
				}
			}
			//顶部回弹
			if (getPositionY() > NONE) tweenLite(NONE);
		}
		
		private function tweenLite(endy:Number, complete:Function = null):void 
		{
			var loader:IBaseSprite = getLoader();
			TweenLite.killTweensOf(loader);
			TweenLite.to(loader, .2, { y: endy,onComplete:complete} );
		}
			
		//mouse move
		private function _onStageMove(e:MouseEvent):void
		{
			if (_isDown)
			{
				var speed:Number = AppWork.stage.mouseY - _currentY;
				//离心力
				if (getPositionY() > NONE && speed > NONE) speed *= _eccentricity;
				if (_isEnd && speed < NONE) speed *= _eccentricity;
				//先绘制
				setPositionY(getPositionY() + speed);
				//重新设置
				_currentY = AppWork.stage.mouseY;
			}
		}
		
		//刷新显示
		public function updateScroll():void
		{
			const locationY:int = -getPositionY();
			_totalSize = 0;
			var beginHigh:Number = 0;			//
			var showHigh:Number = this.limitHeight;
			if (locationY < NONE) showHigh = this.limitHeight + locationY;
			//trace("当前限定高度：", showHigh);
			var item:ListItem;
			_length = _lengApply();
			for (var i:int = 0; i < _length ; i++) 
			{
				const currHigh:Number = _spaceApply(i);
				_totalSize += currHigh;
				if (locationY > _totalSize) continue;
				if (beginHigh > showHigh) break;
				beginHigh += currHigh;
				const bool:Boolean = hasIndex(i);
				item = getItem(i);
				item.setLimit(limitWidth, currHigh);
				if (!bool)
				{
					_rollApply(item);
					item.y = _totalSize - currHigh;
					getLoader().addDisplay(item);
				}
				item.setOpen(true);
			}
			//重绘显示区域
			refresh();
			//判断是否最底端
			_isEnd = (i == _length) && (_totalSize - limitHeight <= Math.abs(getPositionY()));
		}
		
		private function refresh():void
		{
			//重绘
			var renders:Function = function(item:ListItem):void
			{
				if (!item.isOpen()) {
					removeItem(item.floor);
				}else {
					item.setOpen(false);
				}
			}
			if(_itemMap) _itemMap.eachValue(renders);
		}
		
		public function hasIndex(floor:int):Boolean
		{
			if (_itemMap == null) return false;
			return _itemMap.isKey(floor);
		}
		
		public function getItem(floor:int):ListItem
		{
			if (null == _itemMap) _itemMap = new UintHash;
			var item:ListItem = _itemMap.getValue(floor);
			if (null == item) 
			{
				item = getQueue();
				_itemMap.put(floor, item);
				item.setFloor(floor);
			}
			return item;
		}
		
		private function getQueue():ListItem
		{
			return new ListItem;
		}
		
		private function removeItem(floor:int):void
		{
			if (null == _itemMap) return;
			var item:ListItem = _itemMap.remove(floor);
			if(item) item.removeFromFather(true);
		}
		
		//设置停留的位置
		public function selectByFloor(floor:int):void
		{
			var pointy:Number = 0;
			_length = _lengApply();
			for (var i:int = 0; i < _length; i++) 
			{
				if (floor == i) break;
				pointy += _spaceApply(i);
			}
			setPositionY( -pointy);
		}
		
		//这里是浮标
		public function setPositionY(value:Number):void
		{
			if (value == getPositionY()) return;
			getLoader().y = value;
			updateScroll();
		}
		
		//真实位置
		public function getPositionY():Number
		{
			return getLoader().y;
		}
		
		//是否滑动到底部
		public function isScrollLow():Boolean
		{
			return _isEnd;
		}
		
		//是否滚动
		public function isScrollMove():Boolean
		{
			return _isMove;
		}
		
		//一共多少块
		public function set sizeHandler(value:Function):void
		{
			_lengApply = value;
		}
		
		//动态缓冲
		public function set rollHandler(value:Function):void
		{
			_rollApply = value;
		}
		
		//取行高
		public function set spaceHandler(value:Function):void
		{
			_spaceApply = value;
		}
		
		override public function finality(value:Boolean = true):void 
		{
			_rollApply = null;
			_spaceApply = null;
			_lengApply = null;
			_itemMap = null;
			_loader = null;
			_mask = null;
			super.finality(value);
		}
		//ends
	}

}