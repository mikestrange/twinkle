package org.web.sdk.net.http.data 
{
	public class Discern 
	{
		//类型
		//单元形式
		public static const AS_BASE:uint = 1;
		//数组形式
		public static const ARRAY_BASE:uint = 2;
		//类形式
		public static const CLASS_BASE:uint = 3;
		
		//四个条件
		public var key:uint;
		public var type:uint;
		public var name:String;
		public var className:String;
		
		//                      对象名称    类型        外类名              位置
		public function Discern(name:String, type:uint, className:String, key:uint) 
		{
			this.key = key;
			this.type = type;
			this.name = name;
			this.className = className;
		}
		
		public function isMessage():Boolean 
		{	
			return this.type == CLASS_BASE;
		}
			
		public function isList():Boolean
		{
			return this.type == ARRAY_BASE;
		}
		
		/*
		public function toString():String
		{
			return "[ name=" + this.name + ", type=" + this.type + ", className=" + this.className + ", floor=" + this.key + "]";
		}*/
		
		//ends
	}
}