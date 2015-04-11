package org.web.sdk.display.core.com 
{
	import org.web.sdk.display.core.com.interfaces.ITouch;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 选择器
	 */
	public class Chooser 
	{
		//所有列表
		protected var _itemList:Vector.<ITouch>;
		//已经选择的列表
		protected var _selects:Vector.<Number>;
		//最大选取个数
		protected var _maxLeng:int = 1;
		
		public function Chooser(max:int = 1) 
		{
			_selects = new Vector.<Number>;
			setMax(max);
		}
		
		//最多选择的个数
		public function setMax(value:int = 1):void
		{
			_maxLeng = value;
		}
		
		public function get maxLength():int
		{
			return _maxLeng;
		}
		
		//选择个数
		public function get currentLength():int
		{
			return _selects.length;
		}
		
		//
		public function get itemLength():int
		{
			if (_itemList == null) return 0;
			return _itemList.length;
		}
		
		public function setList(vector:Vector.<ITouch>):void
		{
			_itemList = vector;
			for (var i:int = 0; i < _itemList.length; i++) {
				_itemList[i].setFloor(i);
			}
		}
		
		//是否选择
		public function isSelected(index:int):Boolean
		{
			return _selects.indexOf(index) != -1;
		}
		
		//选择
		public function select(value:int):Boolean
		{
			if (null == _itemList) return false;
			var index:int = _selects.indexOf(value);
			if (index != -1) {
				_selects.splice(index, 1);
				_itemList[value].setCancel();
			}else {
				if (isRadio()) restore();
				//
				if (currentLength < maxLength) {
					_selects.push(value);
					_itemList[value].setSelect();
				}else {
					//操作失败
					return false;
				}
			}	
			return true;
		}
		
		//是否单选
		public function isRadio():Boolean
		{
			return _maxLeng == 1;
		}
		
		//全部取消
		public function restore():void
		{
			if (_itemList) {
				for (var i:int = 0; i < _itemList.length; i++)
				{
					if (_itemList[i].isSelected()) _itemList[i].setCancel();
				}
			}
			while (_selects.length) _selects.shift();
		}
		
		public function free():void
		{
			_itemList = null;
		}
		//ends
	}

}