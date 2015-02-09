package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.FrameWork;
	import org.web.sdk.display.ray.RayDisplayer;
	import org.web.sdk.inters.IAcceptor;
	import org.web.sdk.utils.DrawUtils;
	/**
	 * 单一材质  IAcceptor 这个接口才能调度
	 */
	public class SingleTexture extends LibRender
	{
		private var _bitmapdata:BitmapData;
		
		//无名称且milde=true会自动释放
		public function SingleTexture(bit:BitmapData, name:String = null, milde:Boolean = false) 
		{
			this._bitmapdata = bit;
			super(name, milde);
		}
		
		override public function dispose():void
		{
			super.dispose();
			LibRender.release(_bitmapdata);
			_bitmapdata = null;
		}
		
		//通过它去渲染,没有保存那么直接渲染
		override protected function self_render(mesh:IAcceptor):*
		{
			return _bitmapdata;
		}
		
		//ends
	}

}