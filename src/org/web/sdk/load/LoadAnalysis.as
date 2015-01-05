/** 
 *org.web.sdk.load542540443@qq.com 
 *@version 1.0.0 
 * 创建时间：2013-12-5 下午11:46:04 
 **/ 
package org.web.sdk.load
{
	public class LoadAnalysis
	{
		private var _url:String;                //加载路径
		private var _error:Boolean;
		private var _file:String = ""; 	    	//目录(完整父路径)
		private var _label:String = "";   	 	//文件名(标签,在写入对象池的时候很有作用)
		private var _suff:String = "";   		//后缀名
		//
		public function LoadAnalysis(path:String)
		{
			_url = path;
			//解析Url
			var t:int = _url.lastIndexOf("/");
			_file = _url.substr(0, t + 1);
			var h:int = _url.lastIndexOf(".");
			_suff =  _url.substr(h);
			_label = _url.substr(t + 1, h - (t + 1));
		}
		
		//标签 文件名称
		public function get label():String
		{
			return _label;
		}
		
		//后缀
		public function get suff():String
		{
			return _suff;
		}
		
		//路径
		public function get file():String
		{
			return _file;
		}
		
		//链接 
		public function get url():String
		{
			return _url;
		}
		
		//打印
		public function toString():String
		{
			return "loadinfo[ url = '" + _url + "'; file='" + _file + "'; suff = '" + _suff  +"'; label='" + _label +"']";
		}
		
		//取一个路径解析器
		public static function getInfo(url:String):LoadAnalysis
		{
			return new LoadAnalysis(url);
		}
		//ends
	}
}