package org.web.sdk.display.core 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.error.VisualError;
	import org.web.sdk.FrameWork;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	
	/*
	 * 不在乎图片的下载过程，只在乎这种过程中的容器表现形式
	 * */
	public class Image extends Texture 
	{
		private static var MARK_INDEX:uint = 0;
		//
		public var vital:Boolean = false;
		protected var _mark:String = null;
		private var _url:String = null;
		private var _loaderror:Boolean = true;
		private var _complete:Function;
		public var data:Object = null;
		
		public function Image(vital:Boolean = false, called:Function = null) 
		{
			super(null, true);
			_complete = called;
			this.vital = vital;
		}
		
		public function get resource():String
		{
			return _url;
		}
		
		public function isError():Boolean
		{
			return _loaderror;
		}
		
		public function get mark():String
		{
			return _mark;
		}
		
		public function set resource(value:String):void
		{
			if (_url) VisualError.createError(this,'不允许多次下载');
			_url = value;
			if (FrameWork.photo.has(value)) {
				_loaderror = false;
				setBitmapdata(FrameWork.photo.gets(value));
				if (_complete is Function) _complete(this);
			}else {
				_mark = 'MARK_' + (++MARK_INDEX);
				FrameWork.downLoad(value, LoadEvent.IMG, _mark, complete, null, null, vital);	
			}
		}
		
		private function complete(e:LoadEvent):void
		{
			_loaderror = (e.eventType == LoadEvent.ERROR);
			if (_loaderror) {
				//失败派发
				if (_complete is Function) _complete(this);
			}else {
				//成功派发
				FrameWork.photo.share(e.url, e.target as BitmapData);
				setBitmapdata(FrameWork.photo.gets(e.url));
				if (_complete is Function) _complete(this);
			}
		}
		
		//如果没有下载完成肯定要删除标记下载
		override public function dispose():void 
		{
			if (_loaderror) {
				super.dispose();
				if(_mark) PerfectLoader.gets().removeMark(_url, _mark)
			}else {
				FrameWork.photo.remove(_url);
			}
		}
		//ENDS
	}

}