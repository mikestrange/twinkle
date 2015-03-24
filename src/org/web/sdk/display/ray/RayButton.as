package org.web.sdk.display.ray 
{
	import org.web.sdk.display.core.RayDisplayer;
	
	/**
	 * 按钮或者静态开关
	 */
	public class RayButton extends RayDisplayer 
	{
		private var _state:String;
		
		public function RayButton(texture:*=null) 
		{
			super(texture);
		}
		
		public function setNormal():void
		{
			
		}
		
		public function setState(value:String):void
		{
			_state = value;
		}
		
		
		//ends
	}

}