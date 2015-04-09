package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import org.web.sdk.interfaces.IAcceptor;
	import org.web.sdk.display.utils.DrawUtils;
	/**
	 * 单一材质  IAcceptor 这个接口才能调度
	 */
	public class BaseRender extends LibRender
	{
		private var _bitmapdata:BitmapData;
		
		//最简单的一种,直接可以释放
		public function BaseRender(name:String, bit:BitmapData = null, $lock:Boolean = false)
		{
			super(name, $lock);
			_bitmapdata = bit;
		}
		
		override public function dispose():void
		{
			super.dispose();
			if (_bitmapdata) {
				LibRender.release(_bitmapdata);
				_bitmapdata = null;
			}
		}
		
		//通过它去渲染,没有保存那么直接渲染
		override public function createUpdate(data:Object):* 
		{
			if (_bitmapdata == null) _bitmapdata = AssetFactory.getTexture(name);
			return _bitmapdata;
		}
		
		//ends
	}

}