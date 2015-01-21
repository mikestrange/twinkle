package org.web.sdk.net.utils  
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class WebProto 
	{
		//类型
		//单元形式
		public static const AS_BASE:uint = 1;
		//数组形式
		public static const ARRAY_BASE:uint = 2;
		//类形式
		public static const CLASS_BASE:uint = 3;
		
		//
		private var _idTovector:Object = new Object;
		
		//注册委托
		protected function register(key:uint, name:String, type:uint = 1, className:String = ""):void
		{
			if (undefined == _idTovector[key]) {
				_idTovector[key] = new Discern(name, type, className, key);
			}
		}
		
		//通过层级取
		protected function getValue(key:uint):Discern
		{
			return _idTovector[key];
		}
		
		//处理数据  --array/object
		public function read(body:Object):void
		{
			var index:*;
			for (index in body) buffData(index as uint, body[index]);
		}
		
		private function buffData(index:uint, data:*):void
		{
			var dic:Discern = getValue(index);
			if (dic) {
				if (dic.isMessage()) {
					this[dic.name] = getMessage(data, dic.className);
				}else if(dic.isList()) {
					if (null == dic.className || "" == dic.className) {
						this[dic.name] = data;
					}else {
						this[dic.name] = new Array;
						var arr:Array = data as Array;
						var floor:int = 0;
						while (floor < arr.length) {
							this[dic.name].push(getMessage(arr[floor], dic.className));
							floor++;
						}
					}
				}else {
					this[dic.name] = data;
				}
			}
		}
		
		protected function getMessage(data:*, className:String):WebProto
		{
			var webProto:Class = getDefinitionByName(className) as Class;
			var mes:WebProto = new webProto;
			mes.read(data);
			return mes;
		}
		
		//返回一个值键Object
		public function write():Object
		{
			var body:Object = new Object;
			var index:*;
			var dic:Discern;
			var item:*;
			for (index in _idTovector)
			{
				dic = _idTovector[index];
				if (dic.isMessage()) {
					item = WebProto(this[dic.name]).write();
				}else if (dic.isList()) {
					if (this[dic.name] == null) continue;
					if (null == dic.className || "" == dic.className) {
						item = this[dic.name];
					}else {
						item = new Array;
						var arr:Array = this[dic.name] as Array;
						var floor:int = 0;
						while (floor < arr.length) {
							item.push(WebProto(arr[floor]).write());
							floor++;
						}
					}
				}else {
					item = this[dic.name];
				}
				if (undefined != item && null != item) body[dic.key] = item;
			}
			return body;
		}
		
		//基类清除
		public function clear():void
		{
			_idTovector = new Object;
		}
		//ends
	}
}

import org.web.sdk.net.utils.WebProto

class Discern 
{
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
		return this.type == WebProto.CLASS_BASE;
	}
		
	public function isList():Boolean
	{
		return this.type == WebProto.ARRAY_BASE;
	}
		
	public function toString():String
	{
		return "[ name=" + this.name + ", type=" + this.type + ", className=" + this.className + ", floor=" + this.key + "]";
	}
		
	//ends
}