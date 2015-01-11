package org.web.sdk.utils.list
{
	import org.web.apk.beyond_challenge;
	use namespace beyond_challenge
	
	public class ListNode 
	{
		beyond_challenge var stamp:String;
		beyond_challenge var target:* = undefined;
		beyond_challenge var father:ListNode;
		beyond_challenge var next:ListNode;
		
		public function ListNode(name:String, data:*= undefined) 
		{
			stamp = name;
			target = data;
		}
		
		beyond_challenge function setFather(value:ListNode = null):void
		{
			if (value) {
				value.next = this;
				father = value;
			}else {
				father = null;
			}
		}
		
		beyond_challenge function setNext(value:ListNode = null):void
		{
			if (value) {
				next = value;
				value.father = this;
			}else {
				next = null;
			}
		}
		
		public function hasNext():Boolean
		{
			return next != null;
		}
		
		public function hasFather():Boolean
		{
			return father != null;
		}
		
		public function toString():String
		{
			var chat:String = "name:" + stamp;
			if (hasNext()) chat += ", next:" + next.stamp;
			else chat += ", next:null";
			if (hasFather()) chat += ", father:" + father.stamp;
			else chat += ", father:null";
			chat += ", data:" + target;
			return chat;
		}
		
		//ends
	}

}