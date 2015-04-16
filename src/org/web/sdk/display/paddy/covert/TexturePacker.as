package org.web.sdk.display.paddy.covert 
{
	import org.web.sdk.display.paddy.covert.FormatMethod;
	import org.web.sdk.display.paddy.interfaces.IRender;
	/**
	 * ...
	 * @author 打包材质
	 */
	public class TexturePacker extends SmartRender 
	{
		private var _target:Object;
		
		public function TexturePacker(resName:String, data:Object = null) 
		{
			_target = data;
			super(resName, false);
		}
		
		override public function setting(render:IRender, data:FormatMethod = null):void 
		{
			super.setting(render, data);
			render.retakeTarget(_target);
		}
		//ends
	}

}