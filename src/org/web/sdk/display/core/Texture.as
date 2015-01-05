package org.web.sdk.display.core 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import org.web.sdk.display.inters.IBitmap;
	import flash.utils.*;
	/*
	 * 如果要使用纯GPU渲染请使用 starling
	 * */
	public class Texture extends Bitmap implements IBitmap
	{
		public static const AUTO:String = 'auto';	//所有Bitmap的默认方式
		
		public function Texture(bitmapData:BitmapData = null, smoothing:Boolean = true) 
		{
			super(bitmapData, AUTO, smoothing);
		}
		
		//直接从舞台释放
		public function dispose():void
		{
			if (this.bitmapData && this.width + this.height > 0) {
				this.bitmapData.dispose();
				this.bitmapData = null;
			}
		}
		
		//移除 没太大的用处
		public function closed():void
		{
			if (this.parent) this.parent.removeChild(this);
		}
		
		//设置尺寸
		public function setNorms(horizontal:Number = 1, vertical:Number = 1, ratio:Boolean = true):void
		{
			if (ratio) {
				this.scaleX = horizontal;
				this.scaleY = vertical;
			}else {
				this.width = horizontal;
				this.height = vertical;
			}
		}
		
		public function moveTo(mx:Number, my:Number):void
		{
			this.x = mx;
			this.y = my;
		}
		
		//如果设置为null那么就直接删除了
		public function setBitmapdata(bit:BitmapData, smooth:Boolean = true):void
		{
			if (bit == null) {
				dispose();
			}else {
				this.bitmapData = bit;
				this.smoothing = smooth;
			}
		}
		
		//只需要借用bitmapdata就可以了
		public function clone():IBitmap
		{
			var bitmap:IBitmap = new (getDefinitionByName(getQualifiedClassName(this)) as Class);
			bitmap.setBitmapdata(this.bitmapData, this.smoothing);
			return bitmap;
		}
		//ends
	}

}