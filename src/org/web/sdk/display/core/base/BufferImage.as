package org.web.sdk.display.core.base 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.asset.KitBitmap;
	import org.web.sdk.inters.IAcceptor;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	/*
	 * 动态贴图基类,释放完成就可以重新利用
	 * */
	public class BufferImage extends RayDisplayer
	{
		private var _url:String;
		private var _over:Boolean = false;
		
		public function BufferImage(url:String = null)
		{
			if(url) resource = url;
		}
		
		public function get resource():String
		{
			return _url;
		}
		
		//没有释放不能重新设置
		public function set resource(value:String):void
		{
			if (value != null && _url == value) return;
			if (_url) dispose();
			_url = value;
			if (_url) {
				if (LibRender.hasTexture(_url)) {
					setTexture(LibRender.getTexture(_url));
				}else {
					loader.addWait(_url, LoadEvent.IMG).addRespond(complete);
					loader.start();
				}
			}
		}
		
		protected function complete(e:LoadEvent):void
		{
			_over = true;
			if (e.eventType == LoadEvent.COMPLETE) {
				if (LibRender.hasTexture(e.url)) {
					setTexture(LibRender.getTexture(_url));
				}else {
					setTexture(new KitBitmap(e.target as BitmapData, e.url));
				}
			}
			if (e.eventType == LoadEvent.ERROR) _url = null;
			this.dispatchEvent(new Event(e.eventType));
		}
		
		override public function dispose():void 
		{
			if (_url == null) return;
			if (_over) super.dispose();
			else loader.removeRespond(_url, complete);
			_over = false;
			_url = null;
		}
		
		override public function clone():IAcceptor 
		{
			return new BufferImage(this._url);
		}
		//ends
	}

}