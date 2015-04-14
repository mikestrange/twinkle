package org.web.sdk.display.form 
{
	/**
	 * ...
	 * @author Main
	 * 传输方法,填写一个域
	 */
	public class AttainMethod 
	{
		private var _resName:String;
		private var _call:Function;
		private var _type:int = -1;
		
		public function AttainMethod(type:int = -1, resName:String = null, apply:Function = null) 
		{
			_resName = resName;
			_call = apply;
			_type = type;
		}
		
		//所有动作传过来
		public function actionHandler(target:*):void
		{
			if (_call is Function) _call(target);
		}
		
		public function getName():String
		{
			return _resName;
		}
		
		public function getType():int
		{
			return _type;
		}
		//ends
	}

}