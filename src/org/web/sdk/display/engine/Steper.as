package org.web.sdk.display.engine 
{
	import org.web.sdk.interfaces.IDisplay;
	/**
	 *渲染器
	 */
	public class Steper implements IStepper 
	{
		private var isrun:Boolean;
		private var _target:IDisplay;
		
		public function Steper(target:IDisplay) 
		{
			_target = target;
		}
		
		/* INTERFACE org.web.sdk.display.engine.IStepper */
		public function run():void 
		{
			if (isrun) return;
			isrun = true;
			AtomicEngine.run(this);
		}
		
		public function step(event:Object):void 
		{
			_target.frameRender();
		}
		
		public function isRun():Boolean
		{
			return isrun;
		}
		
		public function die():void 
		{
			if (!isrun) return;
			isrun = false;
			AtomicEngine.cut(this);
		}
		//ends
	}

}