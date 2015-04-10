package org.web.sdk.display.game 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.core.SwitcherSprite;
	import org.web.sdk.display.utils.TouchState;
	import org.web.sdk.interfaces.IDisplay;
	/*
	 * 简单的按钮
	 * */
	public class BaseButton extends SwitcherSprite 
	{
		private var _isMouseDown:Boolean = false;
		private var _isMouseOver:Boolean = false;
		//按钮层
		protected var _title:IDisplay;
		protected var _switcher:RayDisplayer;
		
		public function BaseButton(normal:String, press:String = null, over:String = null, die:String = null)
		{
			defineAction(TouchState.NARMAL, normal);
			defineAction(TouchState.PRESS, press);
			defineAction(TouchState.OVER, over);
			defineAction(TouchState.FORBID, die);
		}
		
		override protected function showEvent():void 
		{
			this.buttonMode = true;
			this.mouseChildren = false;	
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseAction);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseAction);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEffect);
			//这个材质在添加到舞台才会被new出来
			_switcher = new RayDisplayer();
			_switcher.addUnder(this, 0);
			_switcher.setLiberty(getSwitcher(TouchState.NARMAL), getSwitcher(TouchState.NARMAL), RayDisplayer.BUTTON_TAG);
		}
		
		override protected function hideEvent():void
		{
			super.hideEvent();
			_switcher.dispose();
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseAction);
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseAction);
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEffect);
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
			else {
				if (_isMouseOver) this.setCurrent(TouchState.OVER);
				else this.setCurrent(TouchState.NARMAL);
			}
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
			if (_switcher) _switcher.flush(worker);
		}
		
		//三种情况，快速的对齐方式
		public function setTitle(title:IDisplay, alige:String = "center"):void
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