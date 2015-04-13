package org.web.sdk.display.form.lib 
{
	import org.web.sdk.display.form.ActionMethod;
	import org.web.sdk.display.form.interfaces.IRender;
	import org.web.sdk.display.form.Texture;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 绑定资源，增加其引用，防止其他地方释放
	 */
	public class AnimationRender extends ResRender
	{
		private var _lists:Vector.<Texture>;
		
		public function AnimationRender(resName:String, vector:Vector.<Texture> = null, $lock:Boolean = false) 
		{
			if (vector) _lists = vector;
			super(resName, $lock);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (_lists) {
				while (_lists.length) {
					_lists.shift().dispose();
				}
				_lists = null;
			}
		}
		
		override public function setPowerfulRender(render:IRender, data:ActionMethod = null):void 
		{
			if (null == _lists) _lists = createVector();
			//传入材质链
			if (data) data.actionHandler(_lists);
		}
		
		protected function createVector():Vector.<Texture>
		{
			return null;
		}
		
		//ends
	}

}