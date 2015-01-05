package org.web.sdk.gpu.interfaces 
{
	import org.web.sdk.gpu.core.TextureConductor;
	
	public interface IMplantation 
	{
		function adaptFor(mark:String,conductor:TextureConductor):void;					//修改和调整
		function setConductor(conductor:TextureConductor):void;
		function getTexure():TextureConductor;
		function isValid():Boolean;											//是否有效
		function render():void;												//渲染
		//ends
	}
	
}