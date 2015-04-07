package org.web.sdk.display.core.base 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.display.asset.LibRender;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.display.asset.KitBitmap;
	import org.web.sdk.inters.IAcceptor;
	import org.web.sdk.load.DownLoader;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.Crystal;
	/*
	 * 动态贴图基类,释放完成就可以重新利用
	 * */
	public class BufferImage extends RayDisplayer
	{
		private var _url:String;
		//自身分配一个下载器
		private var _loader:DownLoader;
		private var _wide:Number;
		private var _heig:Number;
		
		public function BufferImage(url:String = null)
		{
			if(url) resource = url;
		}
		
		public function get resource():String
		{
			return _url;
		}
		
		//最后的尺寸
		override public function setLimit(wide:Number = 0, heig:Number = 0):void 
		{
			super.setLimit(wide, heig);
			this._wide = wide;
			this._heig = heig;
		}
		
		//没有释放不能重新设置
		public function set resource(value:String):void
		{
			_url = value;
			if (_url && !setLiberty(_url))
			{
				//因为忽略了过程，所以complete就必定是结束
				if (null == _loader) {
					_loader = new DownLoader(true, this.complete);
				}
				_loader.load(_url);
				_loader.start();
			}
		}
		
		//就算多个下载也没关系，下载后会清理前面的
		protected function complete(event:LoadEvent):void
		{
			//成功的话就会直接设置
			if (!event.isError && !setLiberty(event.url))
			{
				setTexture(new KitBitmap(event.data as BitmapData, event.url));
			}
		}
		
		override protected function renderBuffer(assets:*):void 
		{
			super.renderBuffer(assets);
			if (!isNaN(_wide)) this.width = _wide;
			if (!isNaN(_heig)) this.height = _heig;
		}
		
		override public function dispose():void 
		{
			if (_loader) {
				_loader.clean();
				_loader = null;
			}
			super.dispose();
		}
		
		override public function clone():IAcceptor 
		{
			return new BufferImage(_url);
		}
		//ends
	}

}