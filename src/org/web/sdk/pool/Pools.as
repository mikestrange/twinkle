package org.web.sdk.pool 
{
	import flash.utils.*;
	
	public class Pools 
	{	
		private static var hashKeys:Object = { };
		
		public static function create(fileName:String="global"):Pools
		{
			if (fileName == null) throw Error('this className is null');
			if (null == Pools.hashKeys[fileName]) {
				Pools.hashKeys[fileName] = new Pools(getDefinitionByName(fileName) as Class, fileName);
			}
			return Pools.hashKeys[fileName];
		}
		
		//class
		private var _className:String;
		private var _pools:Array;
		private var Node:Class;
		
		public function Pools(Title:Class, className:String = null) 
		{
			_pools = new Array;
			_className = className;
			Node = Title;
		}
		
		//取对象并且删除一个对象
		public function getObj(...arg):Object
		{
			if (_pools.length) return _pools.shift();
			return new Node;
		}
		
		//放入对象池 body==null不会被添加
		public function share(body:Object):void
		{
			if (body is Node) _pools.push(body);
		}
		
		//清空，不删除
		public function free():void
		{
			if (_className) {
				if (undefined != hashKeys[_className]) {
					hashKeys[_className] = null;
					delete hashKeys[_className];
				}
			}
			while (_pools.length) _pools.shift();
		}
		
		//ends
	}
}