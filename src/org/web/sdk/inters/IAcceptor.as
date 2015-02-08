package org.web.sdk.inters 
{
	import org.web.sdk.display.asset.LibRender;
	
	public interface IAcceptor extends IDisplayObject 
	{
		//通过名称直接渲染，如果名称找不到，那么就从工厂里面创立
		function setLiberty(txName:String, tag:int = 0):void;
		//渲染材质
		function setTexture(texture:LibRender):void;
		//释放当前的材质
		function dispose():void;
		//复制
		function clone():IAcceptor;
		//ends
	}
}