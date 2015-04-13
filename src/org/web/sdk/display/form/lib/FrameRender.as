package org.web.sdk.display.form.lib 
{
	import org.web.sdk.display.form.Texture;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 绑定资源，增加其引用，防止其他地方释放
	 */
	public class FrameRender extends ResRender
	{
		private var _lists:Vector.<ClassRender>;
		
		public function FrameRender(resName:String, vector:Vector.<ClassRender> = null, $lock:Boolean = false) 
		{
			if (vector) {
				_lists = vector;
				lockList(true);
			}
			super(resName, $lock);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_lists) {
				lockList(false);
				_lists = null;
			}
		}
		
		private function lockList(value:Boolean):void
		{
			if (_lists) {
				for each(var sub:ClassRender in _lists) {
					if (value) sub.addHold();
					else sub.shiftHold();
				}
			}
		}
		
		//get data{frame:1} 传过来的是帧
		override public function createUpdate(data:Object):Texture 
		{
			if (null == _lists) {
				_lists = createVector();
				lockList(true);
			}
			var index:Number;
			if (data is Number) index = Number(data);
			if (!isNaN(index)) return getSub(index).setPowerfulRender();
			return null;
		}
		
		public function getSub(frame:int):ClassRender
		{
			var index:int = frame;
			if (frame < 0) index = 0;
			if (frame >= _lists.length) index = _lists.length - 1;
			return _lists[index];
		}
		
		protected function createVector():Vector.<ClassRender>
		{
			return null;
		}
		
		public function get totals():int
		{
			if (_lists) return _lists.length;
			return 0;
		}
		//ends
	}

}