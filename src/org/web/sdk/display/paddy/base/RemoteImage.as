package org.web.sdk.display.paddy.base 
{
	import org.web.sdk.display.paddy.interfaces.IRender;
	import org.web.sdk.display.paddy.covert.TexturePacker;
	import org.web.sdk.display.paddy.RayObject;
	import org.web.sdk.display.paddy.Texture;
	import org.web.sdk.load.DownLoader;
	import org.web.sdk.load.LoadEvent;
	/*
	 * 远程图片下载
	 * */
	public class RemoteImage extends RayObject
	{
		private var _url:String;
		//自身分配一个下载器
		private var _loader:DownLoader;
		private var _wide:Number;
		private var _heig:Number;
		
		public function RemoteImage(url:String = null)
		{
			if(url) resource = url;
		}
		
		public function get resource():String
		{
			return _url;
		}
		
		//最后的尺寸
		override public function setSize(wide:int, high:int):void 
		{
			super.setSize(wide, high);
			this._wide = wide;
			this._heig = high;
		}
		
		//没有释放不能重新设置
		public function set resource(value:String):void
		{
			_url = value;
			if (_url && !setResource(_url))
			{
				//因为忽略了过程，所以complete就必定是结束
				if (null == _loader) {
					_loader = new DownLoader(this.complete);
				}
				_loader.load(_url);
				_loader.start();
			}
		}
		
		//就算多个下载也没关系，下载后会清理前面的
		protected function complete(event:LoadEvent):void
		{
			//成功的话就会直接设置
			if (!event.isError && !setResource(event.url))
			{
				setBufferRender(new TexturePacker(event.url, new Texture(event.bitmapdata)));
			}
		}
		
		override public function setTexture(texture:Texture):void 
		{
			super.setTexture(texture);
			setScale(_wide / this.width, _heig / this.height);
		}
		
		override public function dispose():void 
		{
			if (_loader) {
				_loader.clean();
				_loader = null;
			}
			super.dispose();
		}
		
		override public function clone():IRender 
		{
			return new RemoteImage(_url);
		}
		//ends
	}

}