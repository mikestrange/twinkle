package org.web.sdk.display.core 
{
	import org.web.sdk.interfaces.ISwitcher;
	import flash.utils.Dictionary;
	import org.web.sdk.display.utils.TouchState;
	
	/**
	 * 一个选择器，可以选择不同的动画？
	 * 基础切换器,一种是可用和不可用的状态
	 */
	public class SwitcherSprite extends BaseSprite implements ISwitcher 
	{
		protected var _current:String;
		protected var _touch:Function;
		protected var _enabled:Boolean = true;
		private var t_map:Dictionary;
		
		public function SwitcherSprite()
		{
			t_map = new Dictionary;
		}
		
		/* INTERFACE org.web.sdk.ui.interfaces.ICooperate */
		public function defineAction(state:String, worker:*= undefined):void 
		{
			if (worker == null) {
				if(t_map[state]) delete t_map[state];
			} else{
				t_map[state] = worker;
			}
		}
		
		public function setNormal(worker:*):void
		{
			defineAction(TouchState.NARMAL, worker);
		}
		
		//当前状态，备用，已经是否强制刷新
		public function setCurrent(state:String, backup:String = "normal"):void 
		{
			if (state == null) state = TouchState.NARMAL;
			_current = state;
			var worker:* = getSwitcher(state);
			if (worker == null) {
				worker = getSwitcher(backup);
			}
			updateSwitcher(worker);
		}
		
		public function get current():String
		{
			return _current;
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
		
		//一个事件处理
		public function set clickHandler(touch:Function):void
		{
			_touch = touch;
		}
		
		//protected ----------
		protected function onTouch():void
		{
			if (_touch is Function) _touch(this);	
		}
		
		//工作状态,子类继承,如果实际应用和当前是一样的话
		protected function updateSwitcher(target:*):void
		{
			
		}
		
		//强制刷新
		public function updateAction():void
		{
			setCurrent(_current);
		}
		
		public function getSwitcher(state:String):*
		{
			return t_map[state];
		}
		
		//end
	}

}