package org.web.sdk.display.inters 
{
	import org.web.sdk.display.core.house.House;
	
	/*
	 * 新窗口就必须借助于House,new House 设置root然后建立新的窗口和图层;
	 * */
	public interface IVision 
	{
		function closed():void;
		//建立图层
		function addLayer(layer:ILayer, floor:int = -1):Boolean;
		//是否图层
		function hasLayer(layerName:String):Boolean;
		//移除图层
		function removeLayer(layerName:String):ILayer;
		//取图层
		function getLayer(layerName:String):ILayer;
		//置顶图层
		function setLayerIndex(layerName:String, top:Boolean = true):void;
		//释放
		function destroy():void 
		//
		function length():Number;
		//
		function get house():House;
		//ends
	}
	
}