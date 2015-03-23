package org.web.sdk.display.core 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import org.web.sdk.display.text.TextEditor;
	import org.web.sdk.display.type.TouchState;
	import org.web.sdk.inters.IBaseSprite;
	import org.web.sdk.inters.IDisplayObject;
	
	public class BaseButton extends SwitcherSprite 
	{
		private var _isMouseDown:Boolean = false;
		private var _isMouseOver:Boolean = false;
		//按钮层
		private var _title:TextEditor;
		private var _bit:RayDisplayer;
		
		public function BaseButton(normal:*, press:*= null, over:*= null)
		{
			super(normal);
			if(press) defineAction(TouchState.PRESS, press);
			if(over) defineAction(TouchState.OVER, over);
		}
		
		override protected function showEvent(e:Object = null):void 
		{
			super.showEvent(e);
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseAction);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseAction);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEffect);
			_bit = new RayDisplayer;
			this.addDisplay(_bit, 0);
			this.setCurrent("");
		}
		
		override protected function hideEvent(e:Object = null):void
		{
			_title = null;
			_bit = null;
			super.hideEvent(e);
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseAction);
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseAction);
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEffect);
			forEach();
			finality();
		}
		
		protected function onClick(e:MouseEvent):void
		{
			onTouch();
		}
		
		protected function onMouseAction(e:MouseEvent):void
		{
			_isMouseDown = (e.type == MouseEvent.MOUSE_DOWN);
			if(_isMouseDown){
				this.setCurrent(TouchState.PRESS);
			}else{
				this.setCurrent(TouchState.NARMAL);
			}
		}
		
		protected function onMouseEffect(e:MouseEvent):void
		{
			_isMouseOver = (e.type == MouseEvent.MOUSE_OVER)
			if(_isMouseOver){
				this.setCurrent(TouchState.OVER);
			}else {
				this.setCurrent(TouchState.NARMAL);
			}
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
			if (worker) _bit.setTexture(worker);
			if(_title) this.addDisplay(_title);
		}
		
		override protected function handlerSwitcher(target:*):void 
		{
			
		}
		
		//三种情况，快速的对齐方式
		public function setTitle(title:*, alige:String = "center"):IDisplayObject
		{
			if (title is String) {
				if(!_title) _title = new TextEditor;
				_title.addText(title, false, 0xff0000, 18);
				_title.setAlign(alige);
				return _title;
			}
			
			return null;
		}
		//ends
	}

}