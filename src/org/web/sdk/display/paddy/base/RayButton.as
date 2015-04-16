package org.web.sdk.display.paddy.base 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.paddy.covert.FormatMethod;
	import org.web.sdk.display.paddy.RayObject;
	import org.web.sdk.display.utils.TouchState;
	import org.web.sdk.global.string;
	/*
	 * 简单的按钮，不能有动画
	 * */
	public class RayButton extends BaseSprite 
	{
		private var _isMouseDown:Boolean = false;
		private var _isMouseOver:Boolean = false;
		//按钮层
		protected var _ray:RayObject;
		protected var _btnName:String;
		protected var _currentType:String;
		protected var _enabled:Boolean = true;
		private var _apply:Function;
		
		public function RayButton(btnName:String)
		{
			_btnName = btnName;
		}
		
		override protected function initialization():void 
		{
			super.initialization();
			_ray = new RayObject;
			_ray.addUnder(this, 0);
			this.buttonMode = true;
			this.mouseChildren = false;	
		}
		
		override protected function showEvent():void 
		{
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMouseAction);
			this.addEventListener(MouseEvent.MOUSE_UP,onMouseAction);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEffect);
			setEnabled(_enabled);	//设置默认状态
		}
		
		override protected function hideEvent():void
		{
			super.hideEvent();
			this.removeEventListener(MouseEvent.CLICK, onClick);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseAction);
			this.removeEventListener(MouseEvent.MOUSE_UP,onMouseAction);
			this.removeEventListener(MouseEvent.MOUSE_OVER,onMouseEffect);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEffect);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			onTouch(event);
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
		
		//这个时候动态的建立资源
		public function setCurrent(type:String):void 
		{
			if (type == _currentType) return;
			_currentType = type;
			//通过解析获得class类
			_ray.setCompulsory(string.format(_btnName, type));
			//如果渲染之后材质没有，那么就设置为默认材质
			if (!_ray.isRender()) setCurrent(TouchState.NARMAL);
		}
		
		public function setEnabled(value:Boolean):void 
		{
			_enabled = value;
			this.mouseEnabled = _enabled;
			if (!value) {
				setCurrent(TouchState.FORBID);
			}else {
				setCurrent(TouchState.NARMAL);
			}
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function get currentType():String
		{
			return _currentType;
		}
		
		public function set touchHandler(value:Function):void
		{
			_apply = value;
		}
		
		protected function onTouch(event:Event):void
		{
			if (_apply is Function) _apply(event);
		}
		
		//ends
	}

}