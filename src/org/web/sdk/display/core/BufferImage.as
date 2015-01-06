package org.web.sdk.display.core 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.FrameWork;
	import org.web.sdk.inters.IAsset;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	import org.web.sdk.display.asset.Assets;
	/*
	 * 动态贴图基类
	 * */
	public class BufferImage extends VRayMap implements IAsset 
	{
		private static var MARK_INDEX:uint = 0;
		private static var MARK:String = "MARK_";
		
		private var _mark:String;
		private var _url:String;
		private var _error:Boolean = false;
		private var _wait:Boolean = false;
		private var _vital:Boolean = false;
		
		public function BufferImage(vital:Boolean = false) 
		{
			this._vital = vital;
			super(null, true);
		}
		
		public function get resource():String
		{
			return _url;
		}
		
		public function isError():Boolean
		{
			return _error;
		}
		
		public function isWait():Boolean
		{
			return _wait;
		}
		
		public function set resource(value:String):void
		{
			if (_wait) dispose();
			_url = value;
			if (Assets.gets().has(value)) {
				Assets.gets().mark(this);
			}else {
				_wait = true;
				_mark = MARK + (++MARK_INDEX);
				FrameWork.downLoad(value, LoadEvent.IMG, _mark, complete, null, null, vital);
			}
		}
		
		private function complete(e:LoadEvent):void
		{
			_error = (e.eventType == LoadEvent.ERROR);
			_mark = null;
			_wait = false;
			if (_error) {
				_url = null;
				this.dispatchEvent(new Event("loadImageError"));
			}else {
				Assets.gets().mark(this, e.target as BitmapData);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function derive(bit:BitmapData):void
		{
			this.setTexture(bit);
		}
		
		override public function dispose():void 
		{
			if (null == _url) return;
			if (_wait) PerfectLoader.gets().removeMark(_url, _mark)
			else Assets.gets().unmark(_url);
			_url = null;
		}
		
		//ends
	}

}