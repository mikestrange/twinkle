package org.web.sdk.gpu 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.FrameWork;
	import org.web.sdk.gpu.texture.VRayTexture;
	import org.web.sdk.inters.IBuffer;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	import org.web.sdk.gpu.Assets;
	/*
	 * 动态贴图基类,释放完成就可以重新利用
	 * */
	public class BufferImage extends VRayMap implements IBuffer 
	{
		private var _url:String;
		private var _over:Boolean = false;
		protected static const asset:Assets = Assets.gets();
		
		public function BufferImage(url:String = null)
		{
			_url = url;
			asset.load(this);
		}
		
		public function get resource():String
		{
			return _url;
		}
		
		//没有释放不能重新设置
		public function set resource(value:String):void
		{
			if (_url) return;
			_url = value;
			asset.load(this);
		}
		
		public function complete(e:LoadEvent):void
		{
			_over = true;
			if (e.eventType == LoadEvent.ERROR) return;
			asset.mark(this, e.target as BitmapData);
			this.dispatchEvent(new Event(e.eventType));
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_url == null) return;
			if (_over) {
				asset.unmark(_url);
			}else {
				asset.loader.removeRespond(_url, complete);
			}
			_url = null;
		}
		//ends
	}

}