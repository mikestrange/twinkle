package org.web.sdk.display.core.com.item 
{
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.core.com.interfaces.IListItem;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public class ListItem extends BaseSprite implements IListItem
	{
		private var _floor:int;
		private var _isopen:Boolean;
		
		public function ListItem(index:int = 0)
		{
			setFloor(index);
		}
		
		public function setFloor(value:int):void
		{
			_floor = value;
		}
		
		public function get floor():int
		{
			return _floor;
		}
		
		public function setOpen(value:Boolean):void
		{
			_isopen = value;
		}
		
		public function isOpen():Boolean
		{
			return _isopen;
		}
		//ends
	}

}