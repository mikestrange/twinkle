package org.web.sdk.utils.list 
{
	import flash.utils.Dictionary;
	/*
	 * 添加是Array的1/20倍，但是取值和删除速度很快
	 * 对于一个建立无关速度,取值查找快的实用，他能实现Array的顺序遍历
	 * */
	public class HashList
	{
		private var hash:Dictionary;
		private var header:ListNode = null;
		private var laster:ListNode = null;
		private var length:int;
		
		public function HashList() 
		{
			hash = new Dictionary;
			length = 0;
		}
		
		public function getHeader():ListNode
		{
			return header;
		}
		
		public function getLaster():ListNode
		{
			return laster;
		}
		
		public function getNode(name:String):ListNode
		{
			return hash[name];
		}
		
		//添加到最后
		public function push(name:String, target:* = undefined):void
		{
			if (hasNode(name)) {
				getNode(name).target = target;
				return;
			}
			var node:ListNode = new ListNode(name, target);
			if (empty()) {
				header = laster = node;
			}else {
				node.setFather(laster);
				laster = node;
			}
			hash[name] = node;
			length++;
		}
		
		//添加到开始
		public function unshift(name:String, target:* = undefined):void
		{
			if (hasNode(name)){
				getNode(name).target = target;
				return;
			}
			var node:ListNode = new ListNode(name, target);
			if (empty()) {
				header = laster = node;
			}else {
				header.setFather(node);
				header = node;
			}
			hash[name] = node;
			length++;
		}
		
		public function getTarget(name:String):*
		{
			var node:ListNode = hash[name];
			if (node) return node.target;
			return null;
		}
		
		public function setTarget(name:String, target:*= undefined):void
		{
			var node:ListNode = hash[name];
			if (node) node.target = target;
		}
		
		//插入
		public function insert(name:String, target:*= undefined , other:String = null, fast:Boolean = false):Boolean
		{
			if (empty() || name == other || other == null || !hasNode(other)) return false;
			var node:ListNode = new ListNode(name, target);
			var item:ListNode = getNode(other);
			if (fast && isHead(other)) header = node;
			if (!fast && isLast(other)) laster = node;
			if (fast) {
				node.setFather(item.father);
				node.setNext(item);
			}else {
				var next:ListNode = item.next;
				item.setNext(node);
				node.setNext(next);
			}
			hash[name] = node;
			length++;
			return true;
		}
		
		//删除第一个
		public function shift():*
		{
			if (null == header) return null;
			return remove(header.stamp);
		}
		
		//最后一个删除
		public function pop():*
		{
			if (null == laster) return null;
			return remove(laster.stamp);
		}
		
		public function remove(node:String):*
		{
			if (!hasNode(node)) return null;
			var item:ListNode = getNode(node);
			length--;
			delete hash[node];
			if (empty()) {
				header = laster = null;
			}else {
				if (isHead(node)) {
					header = item.next;
					header.setFather();
				}
				if (isLast(node)) {
					laster = item.father;
					laster.setNext();
				}
				if (item.hasFather()) {
					item.father.setNext(item.next);
				}
			}
			return item.target;
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
		
		//删除 返回元素
		public function splice(node:String, leng:uint = 1):Array
		{
			var item:ListNode;
			var list:Array = [];
			while (true) {
				item = remove(node);
				if (item == null) break;
				list.push(item.target);
				if (!item.hasNext()) break;
				node = item.next.stamp;
				if (--leng <= 0) break;
			}
			return list;
		}
		
		//循序执行
		public function eachListKeys(called:Function):void
		{
			if (empty()) return;
			var item:ListNode = header;
			while (item != null) {
				called(item.stamp);
				item = item.next;
			}
		}
		
		public function eachListValues(called:Function):void
		{
			if (empty()) return;
			var item:ListNode = header;
			while (item != null) {
				called(item.target);
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
		
		public function clear():void
		{
			if (empty()) return;
			for (var node:String in hash) {
				hash[node] = null;
				delete hash[node];
			}
			length = 0;
			header = null;
			laster = null;
		}
		
		//迭代器
		public function getIterator():Vector.<ListNode>
		{
			if (empty()) return null;
			var vector:Vector.<ListNode> = new Vector.<ListNode>(length);
			var item:ListNode = header;
			var i:int = 0;
			while (item != null) {
				vector[i++] = item;
				item = item.next;
			}
			return vector;
		}
		
		//反序
		public function reverse():void
		{
			if (empty()) return;
			if (length == 1) return;
			var vector:Vector.<ListNode> = new Vector.<ListNode>;
			var item:ListNode = header;
			while (item != null) {
				vector.push(item);
				item = item.next;
			}
			item = header = vector.pop();
			header.setFather();
			for (var i:int = vector.length - 1; i >= 0; i--) {
				item.setNext(vector[i]);
				item = vector[i];
			}
			item.setNext();
			laster = item;
		}
		
		//没有深度复制功能
		public function toString():String
		{
			if (empty()) return "[empty]";
			var chat:String = "-----start-----\nleng:" + length + "\n";
			var item:ListNode = header;
			var index:int = 0;
			while (item != null) {
				chat += "index = "+index+" ["+item.toString()+"]\n";
				item = item.next;
				index++
			}
			chat += "------end-----";
			return chat;
		}
		//end
		
	}

}