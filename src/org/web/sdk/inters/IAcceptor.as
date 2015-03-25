package org.web.sdk.inters 
{
	import org.web.sdk.display.asset.LibRender;
	/*
	 * 一个接受资源的接口
	 * */
	public interface IAcceptor extends IDisplay 
	{
		function flush(data:Object):void;	//跟新
		//通过名称直接渲染，如果名称找不到，那么就从工厂里面创立
		function setLiberty(txName:String, data:Object = null, tag:int = 0):void;
		//设置资源渲染   						是否主动释放上一个引用
		function setTexture(texture:LibRender, data:Object = null):void;
		//取消当前资源管理和自身释放
		function dispose():void;
		//当前的资源渲染器，可以是空
		function get texture():LibRender;
		//复制
		function clone():IAcceptor;
		//ends
	}
}