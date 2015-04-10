package org.web.sdk.display.core.com.scroll 
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.core.utils.ScaleSprite;
	import org.web.sdk.interfaces.IBaseSprite;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 滚动组件
	 */
	public class ScrollSprite extends BaseSprite 
	{
		private static const LIMT:int = 250;
		private var _currentY:Number;
		private var _downY:Number;
		private var _upY:Number;
		private var _interval_Y:Number;
		private var _downTime:int;		//按下时间
		private var _tickTime:int;		//按下到松开时间
		private var _isDown:Boolean;
		private var _isMove:Boolean;
		private var _totals:int;
		private var _indexFloor:int;
		//
		private var _rollApply:Function;
		private var _lineApply:Function;
		//
		private var _loader:IBaseSprite;
		private var _mask:Shape;
		
		override protected function initialization():void 
		{
			super.initialization();
			this.addDisplay(_loader = new BaseSprite);
			//
			var bg:RayDisplayer = ScaleSprite.byPointY("panelBg1", 150, 600);
			_loader.addDisplay(bg);
		}
		
		//设置区域
		override public function setLimit(wide:Number = 0, heig:Number = 0):void 
		{
			super.setLimit(wide, heig);
			if (_mask == null) _mask = new Shape;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,.3);
			_mask.graphics.drawRect(0, 0, wide, heig);
			_mask.graphics.endFill();
			this.addChild(_mask);
			//_loader.mask = _mask;
		}
		
		private function getLoader():IBaseSprite
		{
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
			_interval_Y = _upY = _downY = 0;
			_downTime = _tickTime = 0;
		}
		
		private function _onDown(e:MouseEvent):void
		{
			_isDown = true;
			_downTime = getTimer();
			_currentY = _downY = AppWork.stage.mouseY;
		}
		
		private function _onStageMove(e:MouseEvent):void
		{
			if (_isDown)
			{
				var speed:int = AppWork.stage.mouseY - _currentY;
				var endy:int = _loader.y + speed;
				//先绘制
				renderItems( -endy);				
				//结束位置
				_loader.y = endy;
				//重新设置
				_currentY = AppWork.stage.mouseY;
			}
		}
		
		private function _onStageUp(e:MouseEvent):void
		{
			_isDown = false;
			_tickTime = getTimer() - _downTime;
			_upY = AppWork.stage.mouseY;
			_currentY = 0;
			_interval_Y = Math.abs(_upY - _downY);
			if (_tickTime < LIMT) {
				
			}
		}
		
		//一共多少块
		public function setLength(value:uint):void
		{
			_totals = value;
		}
		
		public function get length():int
		{
			return _totals;
		}
		
		//建立
		public function set rollHandler(value:Function):void
		{
			_rollApply = value;
		}
		
		//取行高
		public function set lineHandler(value:Function):void
		{
			_lineApply = value;
		}
		
		private function getQueue():ListItem
		{
			return new ListItem;
		}
		
		private function renderItems(offy:Number):void
		{
			var i:int = 0;
			var total:Number = 0;
			var begin:int = 0;
			//向下
			var currentHeig:Number = limitHeight;
			if (offy < 0) currentHeig = limitHeight + offy;
			trace("当前限定高度：", currentHeig);
			
			for (i = 0; i < this.length; i++) 
			{
				total += _lineApply(i);
				if (total > offy) 
				{
					if (i != 0) begin = i;
					trace(i)
					break;
				}
			}
			
			//
			var item:ListItem;
			for (i = begin; i < this.length; i++) {
				if (!hasIndex(i)) 
				{
					
					item = getQueue();
					item.setFloor(i);
					_rollApply(item);
					//item.y=
					//getLoader().addDisplay(item);
				}
			}
		}
		
		private function hasIndex(floor:int):Boolean
		{
			return false;
		}
		
		public function updateScroll():void
		{
			
		}
		//ends
	}

}