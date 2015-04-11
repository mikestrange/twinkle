package org.web.sdk.display.core.com.test 
{
	import org.web.sdk.display.core.com.interfaces.ITouch;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public class TouchTest implements ITouch 
	{
		private var _open:Boolean;
		private var _floor:int;
		
		/* INTERFACE org.web.sdk.display.core.com.interfaces.ITouch */
		
		public function get floor():int 
		{
			return _floor;
		}
		
		public function setFloor(value:int):void 
		{
			_floor = value;
		}
		
		public function setSelect():void 
		{
			_open = true;
			trace("选择", _floor);
		}
		
		public function setCancel():void 
		{
			_open = false;
			trace("取消", _floor);
		}
		
		public function isSelected():Boolean 
		{
			return _open;
		}
		
		//ends
	}

}