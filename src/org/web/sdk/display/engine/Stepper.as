package org.web.sdk.display.engine 
{
	/**
	 * ...
	 * 原生态
	 */
	public class Stepper implements IStepper 
	{
		
		/* INTERFACE org.web.sdk.display.engine.IStepper */
		public function run():void 
		{
			Phoebus.run(this);
		}
		
		public function step(event:Object):void 
		{
			
		}
		
		public function cut(type:String = null):void 
		{
			Phoebus.cut(this);
		}
		
		//替代了释放
		public function kill():void 
		{
			
		}
		//ends
	}

}