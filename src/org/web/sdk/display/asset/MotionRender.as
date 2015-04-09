package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import org.web.sdk.global.HashMap;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 动作集合
	 */
	public class MotionRender extends LibRender 
	{
		private var _actionHash:HashMap;
		
		public function MotionRender(libName:String, $lock:Boolean=false) 
		{
			super(libName, $lock);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_actionHash) {
				var vector:Vector.<Vector.<BitmapData>> = Vector.<Vector.<BitmapData>>(_actionHash.getValues());
				var list:Vector.<BitmapData>;
				for (var i:int = vector.length - 1; i >= 0; i--) 
				{
					list = vector[i];
					if (null == list) continue;
					while (list.length) LibRender.release(list.shift());
				}
				_actionHash.clear();
				_actionHash = null;
			}
		}
		
		//如果没有这个动作,那么会去加载或者去建立动作
		override public function createUpdate(data:Object):* 
		{
			trace("________>",data.url, data.action);
			var action:String = data.action;
			var url:String = data.url;	
			if (action == null) return null;	//动作为空的时候不执行
			if (null == _actionHash) _actionHash = new HashMap;
			var vector:Vector.<BitmapData> = _actionHash.getValue(action);
			if (vector == null)
			{
				//通过名称和url取
				vector = AssetFactory.fromVector(action + ".png", "%d", -1, url);
				//
				addAction(action, vector);
				trace(vector)
				return vector;
			}
			return null;
		}
		
		private function addAction(action:String, vector:Vector.<BitmapData>):void
		{
			_actionHash.put(action, vector);
		}
		//ends
	}

}