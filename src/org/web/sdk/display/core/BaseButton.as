package org.web.sdk.display.core 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import org.web.sdk.display.asset.KitBitmap;
	import org.web.sdk.display.utils.TouchState;
	import org.web.sdk.inters.IBaseSprite;
	import org.web.sdk.inters.IDisplayObject;
	
	public class BaseButton extends SwitcherSprite 
	{
		private var _isMouseDown:Boolean = false;
		private var _isMouseOver:Boolean = false;
		//按钮层
		private var _title:IDisplayObject;
		private var _bit:RayDisplayer;
		
		public function BaseButton(normal:String, press:String = null, over:String = null, die:String = null)
		{
			super(normal);
			defineAction(TouchState.PRESS, press);
			defineAction(TouchState.OVER, over);
			defineAction(TouchState.FORBID, die);
		}
		
		override protected function showEvent(e:Object = null):void 
		{
			super.showEvent(e);
			this.buttonMode = true;
			this.mouseChildren = false;	
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseAction);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseAction);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEffect);
		}
		
		override protected function hideEvent(e:Object = null):void
		{
			super.hideEvent(e);
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseAction);
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseAction);
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEffect);
			finality();
		}
		
		protected function onClick(e:MouseEvent):void
		{
			onTouch();
		}
		
		protected function onMouseAction(e:MouseEvent):void
		{
			_isMouseDown = (e.type == MouseEvent.MOUSE_DOWN);
			if (!enabled) return;
			if (_isMouseDown) this.setCurrent(TouchState.PRESS);
			else this.setCurrent(TouchState.NARMAL);
		}
		
		protected function onMouseEffect(e:MouseEvent):void
		{
			_isMouseOver = (e.type == MouseEvent.MOUSE_OVER);
			if (!enabled) return;
			if (_isMouseOver) this.setCurrent(TouchState.OVER);
			else this.setCurrent(TouchState.NARMAL);
		}
		
		public function get isDown():Boolean
		{
			return _isMouseDown;
		}
		
		public function get isOver():Boolean
		{
			return _isMouseOver;
		}
		
		override protected function updateSwitcher(worker:*):void 
		{
			if (!_bit) {
				_bit = new RayDisplayer(worker);
				this.addDisplay(_bit, 0);
			}else {
				if (worker) _bit.setLiberty(worker as String);
			}
		}
		
		//三种情况，快速的对齐方式
		public function setTitle(title:IDisplayObject, alige:String = "center"):void
		{
			if (_title) {
				_title.removeFromFather();
				_title = null;
			}
			_title = title;
			if (_title) {
				_title.setAlign(alige);
				this.addDisplay(_title);
			}
		}
		//ends
	}

}