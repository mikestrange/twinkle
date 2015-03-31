package org.web.sdk.frame.interfaces 
{
	/*
	 * 他只对访问感兴趣
	 * 由于他只是一个通道，任何一个客服都能用,不当当指向某个特定的ClientServer
	 * */
	public interface IVent 
	{
		//提供数据表访问的方法
		function invoke(method:String, data:Object = null, client:*= undefined):void;
		//一个通道可以注册多个数据表
		function register(name:String):IDataTable;
		function destroy(table:IDataTable):void;
		function isEmpty():Boolean;
		//
	}
	
}