package org.web.sdk.display.form.lib 
{
	import org.web.sdk.display.form.lib.AttainMethod;
	import org.web.sdk.display.form.interfaces.IRender;
	/**
	 * ...
	 * @author Main
	 */
	public class BaseRender extends ResRender 
	{
		private var _target:Object;
		
		public function BaseRender(resName:String, data:Object = null) 
		{
			_target = data;
			super(resName, false);
		}
		
		override public function setting(render:IRender, data:AttainMethod = null):void 
		{
			super.setting(render, data);
			render.retakeTarget(_target);
		}
		//ends
	}

}