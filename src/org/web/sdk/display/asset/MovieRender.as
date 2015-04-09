package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import org.web.sdk.interfaces.IAcceptor;
	/*
	 * 动画材质列表
	 * */
	public class MovieRender extends LibRender 
	{
		private var _vector:Vector.<BitmapData>;
		
		public function MovieRender(libName:String, vector:Vector.<BitmapData> = null, $lock:Boolean = false) 
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
		override public function createUpdate(data:Object):* 
		{
			if (null == _vector) trace("自己去建立一个动画吧");
			return _vector;
		}
		
		//ends
	}

}