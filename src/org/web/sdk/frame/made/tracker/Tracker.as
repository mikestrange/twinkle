package org.web.sdk.frame.made.tracker 
{
	import flash.utils.Dictionary;
	import org.web.sdk.frame.made.interfaces.IWrapper;
	/*
	 * 追踪器
	 * */
	public class Tracker
	{
		private var compare:Dictionary = new Dictionary;
		
		public function addListener(name:String, endless:IWrapper):void
		{
			var v:Vector.<IWrapper> = this.compare[name] as Vector.<IWrapper>;
			if (!v) {
				v = new Vector.<IWrapper>;
				this.compare[name] = v;
			}
			v.push(endless);
		}
		
		public function removeListener(name:String, target:Object):void 
		{
			var v:Vector.<IWrapper> = this.compare[name] as Vector.<IWrapper>;
			if (!v) return;
			for (var i:int = v.length - 1; i >= 0; i--)
			{
				if (v[i].match(target)) {
					v[i].destroy();
					v.splice(i, 1);
					break;
				}
			}
			if (v.length == 0) delete this.compare[name];
		}
		
		public function removeLink(name:String = null):void 
		{
			if (name == null) {
				var k:String;
				for (k in this.compare) removeLink(k);
			}else {
				var v:Vector.<IWrapper> = this.compare[name] as Vector.<IWrapper>;
				if (!v) return;
				delete this.compare[name];
				const begin:int = 0;
				while (v.length) {
					v[begin].destroy();
					v.shift();
				}
			}
		}
		
		public function hasListener(name:String):Boolean 
		{
			return this.compare[name] != undefined;
		}
		
		public function sendListener(name:String, event:Object = null):void 
		{
			var v:Vector.<IWrapper> = this.compare[name] as Vector.<IWrapper>;
			if (!v) return;
			var list:Vector.<IWrapper> = v.slice(0, v.length);
			var leng:int = list.length;
			for (var index:int = 0; index < leng; index++) {
				list[index].handler(event);
			}
		}
		
		public function toString():String
		{
			var chat:String = "start->";
			for (var k:String in compare) {
				chat += "\nkey=" + k + ", list=" + compare[k];
			}
			chat+="\n<-end"
			return chat;
		}
		//ends
	}
}