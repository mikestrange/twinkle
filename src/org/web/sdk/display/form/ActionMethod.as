package org.web.sdk.display.form 
{
	/**
	 * ...
	 * @author Main
	 */
	public class ActionMethod 
	{
		private var _action:String;
		private var _call:Function;
		
		public function ActionMethod(action:String = null, apply:Function = null) 
		{
			_action = action;
			_call = apply;
		}
		
		//所有动作传过来
		public function actionHandler(target:*):void
		{
			if (_call is Function) _call(target);
		}
		
		public function getName():String
		{
			return _action;
		}
		//ends
	}

}