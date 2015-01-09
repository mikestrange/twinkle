package org.web.sdk.display.core 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.display.Multiple;
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
		private var _url:String;
		private var _wide:Number;
		private var _heig:Number;
		private var _error:Boolean = false;
		private var _wait:Boolean = false;
		private var _vital:Boolean = false;
		private var _ishave:Boolean = false;
		
		public function BufferImage(url:String = null, wide:Number = NaN, heig:Number = NaN, color:uint = 0, vital:Boolean = false) 
		{
			this._vital = vital;
			super(createdef(wide, heig), true);
			this.resource = url;
		}
		
		private function createdef(wide:Number = NaN, heig:Number = NaN, color:uint = 0):BitmapData
		{
			if (!isNaN(wide) && !isNaN(heig)) {
				_ishave = true;
				_wide = wide;
				_heig = heig;
				return new BitmapData(wide, heig, false, color);
			}
			return null;
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
			if (value == null || value == "") return;
			if (!_wait) stopUnmark();
			_url = value;
			if (Assets.gets().has(value)) {
				Assets.gets().mark(this);
			}else {
				_wait = true;
				FrameWork.downLoad(value, LoadEvent.IMG, complete, null, null, _vital);
			}
		}
		
		private function complete(e:LoadEvent):void
		{
			_error = (e.eventType == LoadEvent.ERROR);
			_wait = false;
			if (_error) {
				_url = null;
			}else {
				freedef();
				Assets.gets().mark(this, e.target as BitmapData);
				if (!isNaN(_wide) && !isNaN(height)) this.setNorms(_wide, _heig, false);
			}
			//结果处理
			handler(_error);
		}
		
		protected function handler(error:Boolean):void
		{
			
		}
		
		public function derive(bit:BitmapData):void
		{
			this.setTexture(bit);
		}
		
		private function freedef():void
		{
			if (_ishave) {
				_ishave = false;
				Multiple.dispose(this.bitmapData);
			}
		}
		
		override public function dispose():void 
		{
			freedef();
			stopUnmark();
		}
		
		private function stopUnmark():void
		{
			if (null == _url) return;
			if (_wait) PerfectLoader.gets().removeRespond(_url, complete);
			else Assets.gets().unmark(_url);
			_url = null;
		}
		
		//ends
	}

}