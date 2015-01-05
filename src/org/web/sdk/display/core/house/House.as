package org.web.sdk.display.core.house 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import org.web.sdk.display.inters.ILayer;
	import org.web.sdk.display.inters.IVision;
	import org.web.sdk.log.Log;
	import org.web.sdk.system.EternalMessage;
	
	final public class House
	{
		public var root:DisplayObjectContainer = null;
		
		//添加或者移除的时候会发送命令
		public static const ADD_VISION:String = 'addvision';
		public static const REMOVE_VISION:String = 'removevision';	
		
		//在于快速创建一个可视化舞台的所有层次:  视角->Layer->Sprite->suns
		private static var house:House;	
		
		public static function get nativer():House
		{
			if (house == null) house = new House;
			return house;
		}
		
		//添加的时候全局通知
		internal function addVision(vision:IVision):void
		{
			Log.log(this).debug(this, 'add ->LLVision', vision);
			EternalMessage.sendMessage(ADD_VISION, this, vision);
		}
		
		//全局通知移除
		internal function removeVision(vision:IVision):void
		{
			Log.log(this).debug(this, 'remove->', vision);
			EternalMessage.sendMessage(REMOVE_VISION, this, vision);
		}
		
		//当前多少个窗口
		public function length():Number
		{
			return root.numChildren;
		}
		
		//取窗口视角
		public function getVisionByName(visionName:String = null):IVision
		{
			return root.getChildByName(getName(visionName)) as IVision;
		}
		
		//是否存在视角
		public function hasVisionInHouse(visionName:String = null):Boolean
		{
			return getVisionByName(getName(visionName)) != null;
		}
		
		//移除某个窗口视角
		public function removeVisionByName(visionName:String = null):IVision
		{
			var dis:IVision = getVisionByName(getName(visionName));
			if(dis) dis.closed();
			return dis;
		}
		
		private function getName(visionName:String):String
		{
			return visionName == null ? SoleVision.DEF_VISION : visionName
		}
		
		//置顶一个视角窗口
		public function sweptIndexByName(visionName:String = null, floor:int = -1):void
		{
			var dis:IVision = getVisionByName(getName(visionName));
			if (dis) {
				if (root.numChildren < 1) return;
				if (floor >= root.numChildren || floor < 0) floor = root.numChildren - 1;
				root.setChildIndex(dis as DisplayObject, floor);
			}
		}
		
		//取一个窗口图层 Layer
		public function getLayer(layerName:String, visionName:String = null):ILayer
		{
			var dis:IVision = getVisionByName(visionName);
			if (dis) return dis.getLayer(layerName);
			return null;
		}
		
		//移除一个窗口图层 Layer
		public function removeLayer(layerName:String, visionName:String = null):ILayer
		{
			var dis:IVision = getVisionByName(visionName);
			return dis.removeLayer(layerName);
		}
		
		//为窗口添加图层 Layer
		public function addLayer(layer:ILayer, visionName:String = null):Boolean
		{
			var dis:IVision = getVisionByName(visionName);
			if (dis == null) {
				dis = new SoleVision(this, visionName);
				root.addChild(dis as DisplayObject);
			}
			return dis.addLayer(layer, dis.length());
		}
		
		public function toString():String
		{
			return '[House]';
		}
		
		//ends
	}

}