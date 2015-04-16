package org.web.sdk.display.paddy.covert 
{
	import org.web.sdk.global.string;
	/**
	 * ...
	 * @author Main
	 * 传输方法,在table中他创建了属于自己的类型Res
	 * 创建的格式方法
	 */
	public class FormatMethod 
	{
		private var _type:int;
		private var _format:String;
		private var _namespaces:String;
		
		public function FormatMethod(format:String, namespaces:String = null, type:int = 0) 
		{
			_type = type;
			_format = format;
			_namespaces = namespaces;
		}
		
		public function getType():int
		{
			return _type;
		}
		
		public function getNamespace():String
		{
			return _namespaces;
		}
		
		//完整路径，我们不根据材质名称去获取，这里只是作为一个标志
		public function getFormat():String
		{
			return _format;
		}
		
		public function getResName():String
		{
			if (_namespaces == null) return _format;
			return _namespaces + "@" + _format;
		}
		//ends
	}

}