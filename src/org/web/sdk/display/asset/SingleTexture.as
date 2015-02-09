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
		
		//**************************************************
		//----直接汇入
		public static function fromBitmapData(bitdata:BitmapData):SingleTexture
		{
			return new SingleTexture(bitdata);
		}
		
		//可以是displayer，movieclip,bitmapdata
		public static function fromClassName(className:String, url:String = null):SingleTexture
		{
			if (url == null) return fromLocalClassName(className);
			//ends
			var bit:BitmapData = FrameWork.getAsset(className, url);
			if (bit == null) return null;
			return fromBitmapData(bit);
		}
		
		//本地共享
		public static function fromLocalClassName(className:String):SingleTexture
		{
			var Objects:Class = getDefinitionByName(className) as Class;
			var item:* = new Objects(); //MovieClip不处理
			if (item == null) return null;
			if (item is DisplayObject) return fromBitmapData(DrawUtils.draw(item as DisplayObject));
			return fromBitmapData(item as BitmapData);
		}
		
		//根据一个泛型类，注入替换字符,不会被存入
		public static function fromBitVector(className:String, form:String, last:int = -1, url:String = null):Vector.<BitmapData>
		{
			var vector:Vector.<BitmapData> = new Vector.<BitmapData>;
			var index:int = 1;	//0开始
			var name:String;
			var bitdata:BitmapData;
			while (true) {
				name = className.replace(form, index);
				bitdata = FrameWork.getAsset(name, url);
				if (null == bitdata) break;
				vector.push(bitdata);
				if (++index > last && last != -1) break;
			}
			return vector;
		}
		//ends
	}

}