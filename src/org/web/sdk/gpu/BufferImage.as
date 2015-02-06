package org.web.sdk.gpu 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.FrameWork;
	import org.web.sdk.gpu.texture.BaseTexture;
	import org.web.sdk.inters.IAcceptor;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	import org.web.sdk.gpu.Assets;
	/*
	 * 动态贴图基类,释放完成就可以重新利用
	 * */
	public class BufferImage extends VRayMap
	{
		private var _url:String;
		private var _over:Boolean = false;
		private var _wide:Number;
		private var _heig:Number;
		private var _def:Class;
		
		public function BufferImage(url:String = null, wide:Number = 0, heig:Number = 0, classN:Class = null)
		{
			this._wide = wide;
			this._heig = heig;
			this._def = classN;
			if(url) resource = url;
		}
		
		override public function get resource():String
		{
			return _url;
		}
		
		//没有释放不能重新设置
		public function set resource(value:String):void
		{
			if (_url) return;
			_url = value;
			asset.load(this, complete);
		}
		
		public function complete(e:LoadEvent):void
		{
			_over = true;
			if (e.eventType == LoadEvent.ERROR) {
				if(_def) asset.mark(this, _url, new BaseTexture(new _def));
			}else {
				asset.mark(this, _url, BaseTexture.fromBitmapData(e.target as BitmapData));
			}
			this.dispatchEvent(new Event(e.eventType));
		}
		
		override public function setTexture(texture:BaseTexture):void 
		{
			super.setTexture(texture);
			if (_wide+_heig != 0) this.setNorms(_wide, _heig, false);
		}
		
		override public function dispose():void 
		{
			if (_url == null) return;
			if (_over) {
				asset.unmark(_url);
			}else {
				asset.loader.removeRespond(_url, complete);
			}
			_url = null;
		}
		
		override public function clone():IAcceptor 
		{
			return new BufferImage(this._url);
		}
		//ends
	}

}