package org.web.sdk.utils.list
{
	public class ListNode 
	{
		private var _name:String;
		private var _father:ListNode;
		private var _next:ListNode;
		private var _target:*= undefined;
		
		public function ListNode(name:String, data:*= undefined) 
		{
			_name = name;
			_target = data;
		}
		
		public function get next():ListNode
		{
			return _next;
		}
		
		public function get father():ListNode
		{
			return _father;
		}
		
		public function get stamp():String 
		{	
			return _name;
		}
		
		public function get target():*
		{
			return _target;
		}
		
		internal function setFather(value:ListNode = null):void
		{
			if (value) {
				value._next = this;
				_father = value;
			}else {
				_father = null;
			}
		}
		
		internal function setNext(value:ListNode = null):void
		{
			if (value) {
				_next = value;
				value._father = this;
			}else {
				_next = null;
			}
		}
		
		public function hasNext():Boolean
		{
			return this._next != null;
		}
		
		public function hasFather():Boolean
		{
			return this._father != null;
		}
		
		public function toString():String
		{
			var chat:String = "name:" + _name;
			if (hasFather()) chat += ", father:" + _father.stamp;
			else chat += ", father:null";
			if (hasNext()) chat += ", next:" + _next.stamp;
			else chat += ", next:null";
			return chat;
		}
		
		//ends
	}

}