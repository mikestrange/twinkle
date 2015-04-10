package org.web.sdk.display.core.com.scroll 
{
	import org.web.sdk.display.core.BaseSprite;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public class ListItem extends BaseSprite 
	{
		private var _itemHeig:int;
		private var _floor:int;
		
		public function setItemSize(h:int, w:int = 0):void
		{
			setLimit(w, h);
			_itemHeig = h;
		}
		
		public function getItemHeight():int
		{
			return _itemHeig;
		}
		
		public function setFloor(value:int):void
		{
			_floor = value;
		}
		
		public function get floor():int
		{
			return _floor;
		}
		
		//ends
	}

}