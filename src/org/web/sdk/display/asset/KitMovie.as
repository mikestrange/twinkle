package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import org.web.sdk.interfaces.IAcceptor;
	/*
	 * 动画材质列表
	 * */
	public class KitMovie extends LibRender 
	{
		private var _vector:Vector.<BitmapData>;
		
		public function KitMovie(vector:Vector.<BitmapData>, libName:String = null, $lock:Boolean = false) 
		{
			_vector = vector;
			super(libName, $lock);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_vector) {
				while (_vector.length) {
					LibRender.release(_vector.shift());
				}
				_vector = null;
			}
		}
		
		//我们可以根据一个名称来取一个链表影片
		override public function update(data:Object):* 
		{
			return _vector;
		}
		
		//ends
	}

}