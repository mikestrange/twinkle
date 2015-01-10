package org.web.sdk.utils.list 
{
	import flash.utils.Dictionary;
	
	public class HashList{
		private var hash:Dictionary;
		private var header:ListNode = null;
		private var laster:ListNode = null;
		private var length:int;
		
		public function HashList() 
		{
			hash = new Dictionary;
			length = 0;
		}
		
		//添加到最后
		public function push(node:ListNode):void
		{
			if (hasNode(node.stamp)) throw Error("命名重复");
			if (empty()) {
				header = laster = node;
			}else {
				node.setFather(laster);
				laster = node;
			}
			hash[node.stamp] = node;
			length++;
		}
		
		//添加到开始
		public function unshift(node:ListNode):Boolean
		{
			if (hasNode(node.stamp)) throw Error("命名重复");
			if (empty()) {
				header = laster = node;
			}else {
				header.setFather(node);
				header = node;
			}
			hash[node.stamp] = node;
			length++;
			return true;
		}
		
		public function getNode(stamp:String):ListNode
		{
			return hash[stamp];
		}
		
		//插入
		public function insert(node:ListNode, stamp:String = null, fast:Boolean = false):void
		{
			if (node.stamp == stamp || stamp == null || !hasNode(stamp)){
				if (fast) unshift(node);
				else push(node);
				return;
			}
			if (empty()) {
				header = laster = node;
			}else {
				var item:ListNode = getNode(stamp);
				if (isHead(stamp) && fast) header = node;
				if (isLast(stamp) && !fast) laster = node;
				if (fast) {
					item.setFather(node);
				}else {
					var next:ListNode = item.next;
					item.setNext(node);
					node.setNext(next);
				}
			}
			hash[node.stamp] = node;
			length++;
		}
		
		//删除第一个
		public function shift():ListNode
		{
			if (null == header) return null;
			return remove(header.stamp);
		}
		
		//最后一个删除
		public function pop():ListNode
		{
			if (null == laster) return null;
			return remove(laster.stamp);
		}
		
		public function remove(node:String):ListNode
		{
			if (!hasNode(node)) return null;
			var item:ListNode = getNode(node);
			length--;
			delete hash[node];
			if (empty()) {
				header = laster = null;
			}else {
				if (isHead(node)) header = item.next;
				if (isLast(node)) laster = item.father;
				if (item.hasFather()) item.father.setNext(item.next);
			}
			return item;
		}
		
		public function size():int
		{
			return length;
		}
		
		public function empty():Boolean
		{
			return length == 0;
		}
		
		public function hasNode(node:String):Boolean
		{
			return hash[node] != undefined;
		}
		
		//删除
		public function splice(index:int = 0, leng:uint = 1):Array
		{
			if (index > length - 1) return null;
			var len:int = 0;
			var list:Array = [];
			var item:ListNode = header;
			var i:int = 0;
			while (true) {
				if (i >= index) {
					list.push(item);
					remove(item.stamp);
					if (++len == leng) break;
				}
				++i;
				if (!item.hasNext()) break;
				item = item.next;
			}
			return list;
		}
		
		public function eachKeys(called:Function):void
		{
			if (length == 0) return;
			var item:ListNode = header;
			while (item != null) {
				called(item.stamp);
				item = item.next;
			}
		}
		
		public function eachValues(called:Function):void
		{
			if (length == 0) return;
			var item:ListNode = header;
			while (item != null) {
				called(item);
				item = item.next;
			}
		}
		
		public function isHead(node:String):Boolean
		{
			if (header == null) return false;
			return header.stamp == node;
		}
		
		public function isLast(node:String):Boolean
		{
			if (laster == null) return false;
			return laster.stamp == node;
		}
		
		public function toString():String
		{
			var chat:String = "leng:"+length+"\n";
			if (length == 0) return "[empty]";
			var item:ListNode = header;
			var index:int = 0;
			while (item != null) {
				chat += "index = "+index+" ["+item.toString()+"]\n";
				item = item.next;
				index++
			}
			return chat;
		}
		//end
		
	}

}