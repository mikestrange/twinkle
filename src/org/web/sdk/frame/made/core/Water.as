package org.web.sdk.frame.made.core 
{
	public class Water 
	{
		public static const BEGIN:int = 0;
		//
		private var _name:String;
		private var _carry:Array;
		private var _target:Object;
		private var _leng:int;
		private var _pointer:int;
		
		public function Water(name:String, target:Object, parameters:Array) 
		{
			_name = name;
			_target = target;
			_carry = parameters;
			_leng = _carry.length;
			_pointer = BEGIN;
		}
		
		public function read(index:int = -1):*
		{
			if (index >= BEGIN) _pointer = index;
			var f:int = _pointer++;
			if (_leng > f) return _carry[f];
			return null;
		}
		
		public function restore():void
		{
			_pointer = 0;
		}
		
		public function hasNext():Boolean
		{
			return _leng > _pointer;
		}
		
		public function get length():int
		{
			return _leng;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get target():Object
		{
			return _target;	
		}
		
		//end
	}

}