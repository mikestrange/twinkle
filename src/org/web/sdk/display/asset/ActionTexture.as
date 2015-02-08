package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import org.web.sdk.display.ray.ActionMovie;
	import org.web.sdk.inters.IAcceptor;
	import org.web.sdk.utils.HashMap;
	
	public class ActionTexture extends LibRender 
	{
		private var _actionHash:HashMap;
		
		public function ActionTexture(libName:String = null, milde:Boolean = false) 
		{
			_actionHash = new HashMap;
			super(libName, milde);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_actionHash) {
				var vector:Vector.<Vector.<BitmapData>> = Vector.<Vector.<BitmapData>>(_actionHash.getValues());
				var list:Vector.<BitmapData>;
				for (var i:int = vector.length - 1; i >= 0; i--) {
					list = vector[i];
					if (null == list) continue;
					while (list.length) LibRender.release(list.shift())
				}
				_actionHash.clear();
				_actionHash = null;
			}
		}
		
		//如果没有这个动作,那么会去加载或者去建立动作
		override protected function self_render(mesh:IAcceptor):* 
		{
			if (null == _actionHash) return null;
			var movie:ActionMovie = mesh as ActionMovie;
			if (movie.action == null) return null;
			var vector:Vector.<BitmapData>;
			if (_actionHash.isKey(movie.action)) {
				vector = _actionHash.getValue(movie.action);
			}else {
				//不存在的话，告诉呈现者，你需要去创造
				vector = movie.createAction(movie.action);
				//保存动作
				addAction(movie.action, vector);	
			}
			return vector;
		}
		
		private function addAction(action:String,vector:Vector.<BitmapData>):void
		{
			_actionHash.put(action, vector);
		}
		//ends
	}

}