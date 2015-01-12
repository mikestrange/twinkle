package org.web.sdk.utils.list
{
	public class ListNode 
	{
		public var target:* = undefined;
		internal var stamp:String;
		internal var father:ListNode;
		internal var next:ListNode;
		
		public function ListNode(key:String, data:*= undefined) 
		{
			stamp = key;
			target = data;
		}
		
		public function getName():String
		{
			return stamp;
		}
		
		public function getNext():ListNode
		{
			return next;
		}
		
		public function getFather():ListNode
		{
			return father;
		}
		
		public function hasNext():Boolean
		{
			return next != null;
		}
		
		public function hasFather():Boolean
		{
			return father != null;
		}
		
		internal function setFather(value:ListNode = null):void
		{
			if (value) {
				value.next = this;
				father = value;
			}else {
				father = null;
			}
		}
		
		internal function setNext(value:ListNode = null):void
		{
			if (value) {
				next = value;
				value.father = this;
			}else {
				next = null;
			}
		}
		
		public function toString():String
		{
			var chat:String = "name:" + stamp;
			if (next) chat += ", next:" + next.stamp;
			else chat += ", next:null";
			if (father) chat += ", father:" + father.stamp;
			else chat += ", father:null";
			chat += ", data:" + target;
			return chat;
		}
		
		//ends
	}

}