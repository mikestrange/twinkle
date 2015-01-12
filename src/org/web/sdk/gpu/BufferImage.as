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
	 * 动态贴图基类
	 * */
	public class BufferImage extends VRayMap implements IBuffer 
	{
		private var _url:String;
		private var _wide:Number;
		private var _heig:Number;
		protected static const asset:Assets = Assets.gets();
		
		public function BufferImage(url:String = null) 
		{
			_url = url;
		}
		
		public function get resource():String
		{
			return _url;
		}
		
		public function load():void
		{
			asset.load(this);
		}
		
		public function complete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) return;
			asset.mark(this, e.target as BitmapData);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			asset.loader.removeRespond(_url, complete);
		}
		//ends
	}

}