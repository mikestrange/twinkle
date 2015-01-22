package org.web.sdk.error 
{
	import org.web.sdk.utils.ClassUtils;
	/**
	 * ...
	 * 可视化错误
	 */
	public class VisualError extends Error 
	{
		public static const NONE:int = 0;
		public static const ERROR:String = 'def error';
		
		public function VisualError(message:String, id:int= NONE, cast:Boolean = true) 
		{
			super(message, id);
			if (cast) throw this;
		}
		
		//建立一个错误
		public static function createError(target:Object = null, type:String = ERROR, index:int = NONE, cast:Boolean = true):VisualError
		{
			var chat:String;
			if (target == null) chat = "[ NONE ]->" + type+" : " + index;
			else chat = "[ " + ClassUtils.getClassName(target) + " ] ->" + type+" : " + index;
			return new VisualError(chat, index, cast);
		}
		
		//ends
	}

}