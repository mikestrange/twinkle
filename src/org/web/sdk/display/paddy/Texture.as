package org.web.sdk.display.paddy 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import org.web.sdk.interfaces.IDisplayObject;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	public class Texture 
	{
		private static const NONE:int = 0;
		//缓存的材质
		private var _bit:BitmapData;
		//x和y在帧动画中起作用
		private var _sizeWidth:Number;
		private var _sizeHeight:Number;
		
		public function Texture(bit:BitmapData, sizew:Object = null, sizeh:Object = null)
		{
			this._bit = bit;
			this.setSize(parseFloat(String(sizew)), parseFloat(String(sizeh)));
		}
		
		public function dispose():void
		{
			if (_bit && _bit.width > NONE && _bit.height > NONE) 
			{
				_bit.dispose();
				_bit = null;
			}
		}
		
		//设置尺寸
		public function setSize(width:Number, height:Number):void
		{
			if (!isNaN(width)) _sizeWidth = width;
			if (!isNaN(height)) _sizeHeight = height;
		}
		
		public function getImage():BitmapData
		{
			return _bit;
		}
		//ends
	}

}