package org.web.sdk.system.inter 
{
	/*
	 * 数据模块,可以对逻辑的状态绑定，也就是访问的回调,发送数据也可以
	 * */
	public interface IDataBank
	{
		//数据
		function get data():Object;
		//行为
		function action():void;
		//摧毁整个数据包
		function destroy():void;
		//ends
	}
	
}