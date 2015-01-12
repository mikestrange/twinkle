package org.web.sdk.inters 
{
	import org.web.sdk.gpu.shader.CryRenderer;
	/*
	 * 逐步呈现
	 * */
	public interface IEscape 
	{
		//设置渲染器
		function setConductor(conductor:CryRenderer):void;
		//渲染器
		function getRenderer():CryRenderer;
		//是否有效
		function isValid():Boolean;
		//通知渲染
		function sendRender(type:String, data:Object = null):void;
		//处理渲染
		function updateRender(code:String, data:*= undefined):void;
		//最终渲染
		function render():void;	
		//end
	}
	
}