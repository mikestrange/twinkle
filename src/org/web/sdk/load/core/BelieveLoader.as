package org.web.sdk.load.core 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	import org.web.sdk.utils.HashMap;
	
	public class BelieveLoader extends EventDispatcher 
	{
		private static var _loader:PerfectLoader = PerfectLoader.gets();
		private static var INDEX:int = 0;
		//
		private var loadList:Vector.<String>
		private var _totals:int;
		private var _position:int;
		private var _hash:HashMap;
		//
		public function BelieveLoader() 
		{
			loadList = new Vector.<String>;
			_hash = new HashMap;
		}
		
		public function add(url:String, type:int = LoadEvent.IMG, context:*= undefined):void
		{
			if (loadList.indexOf(url) != -1) return;
			loadList.push(url);
			_loader.addWait(url, type, context).addRespond("mark" + (++INDEX), complete);
			_totals = loadList.length;
		}
		
		public function start():void
		{
			_loader.startLoad();
		}
		
		private function complete(e:LoadEvent):void
		{
			_position++;
			if (e.eventType == LoadEvent.COMPLETE) {
				_hash.put(e.url, e.target);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}else {
				this.dispatchEvent(new Event("errorLoader"));
			}
			if (_position == _totals) this.dispatchEvent(new Event("allComplete"));
		}
		
		public function getData(url:String):*
		{
			return _hash.getValue(url);
		}
		
		public function stop():void
		{
			for each(var url:String in loadList) {
				_loader.removeMark(url);
			}
		}
		
		public function clear():void
		{
			stop();
			_hash.clear();
		}
			
		public function get totals():int
		{
			return _totals;
		}
		
		public function get position():int
		{
			return _position;
		}
		
		//ends
	}

}
