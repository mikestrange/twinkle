package org.web.sdk.display.form 
{
	import org.web.sdk.global.string;
	/**
	 * ...
	 * @author Main
	 * 传输方法,在table中他创建了属于自己的类型Res
	 * 中介传媒
	 */
	public class AttainMethod 
	{
		private var _type:int;
		private var _apply:Function;
		private var _resName:String;
		private var _namespaces:String;
		
		public function AttainMethod(type:int, resName:String = null, call:Function = null) 
		{
			_apply = call;
			_type = type;
			_resName = resName;
		}
		
		public function getType():int
		{
			return _type;
		}
		
		public function setResName(value:String):void
		{
			_resName = value;
		}
		
		public function getResName():String
		{
			return _resName;
		}
		
		//空间命名，只是一个不同的标示而已
		public function setNamespace(value:String):void
		{
			_namespaces = value;
		}
		
		public function getNamespace():String
		{
			return _namespaces;
		}
		
		//回调一个数据
		public function actionHandler(target:*= undefined):void
		{
			if (_apply is Function) _apply(target); 
		}
		
		//完整路径，我们不根据材质名称去获取，这里只是作为一个标志
		public function getFile():String
		{
			if (_namespaces == null) return _resName;
			return string.format("path:%t_name:%t", _namespaces, _resName);
		}
		//ends
	}

}