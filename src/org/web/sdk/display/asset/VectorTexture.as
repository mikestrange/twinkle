package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import org.web.sdk.inters.IAcceptor;
	
	public class VectorTexture extends LibRender 
	{
		private var _vector:Vector.<BitmapData>;
		
		public function VectorTexture(vector:Vector.<BitmapData>, libName:String = null, milde:Boolean = false) 
		{
			_vector = vector;
			super(libName, milde);
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
		
		override protected function self_render(mesh:IAcceptor):* 
		{
			return _vector;
		}
		
		//ends
	}

}