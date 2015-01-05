package org.web.sdk.gpu.actions.texture 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import org.web.sdk.FrameWork;
	import org.web.sdk.gpu.interfaces.IMplantation;
	import org.web.sdk.gpu.core.TextureConductor;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.load.PerfectLoader;
	import org.web.sdk.utils.HashMap;
	
	//动态库，大部分相同的保存在同一库下,这里必须做一个标记，下载过的标记
	public class ActionTexture extends TextureConductor 
	{
		private static var INDEX:int = 0;
		//
		private var actionHash:HashMap;
		private var vector:Vector.<String>;
		
		public function ActionTexture(key:String) 
		{
			super(key);
		}
		
		override protected function initialization(value:Boolean):void 
		{
			if (value) {
				vector = new Vector.<String>;
				actionHash = new HashMap;
			}
		}
		
		//动态渲染
		public function load(url:String, action:IMplantation, mark:String = null):void
		{
			if (FrameWork.app.has(url)) {
				action.adaptFor(url, this);
			}else {
				vector.push(url);
				FrameWork.downLoad(url, LoadEvent.SWF, "mark" + (INDEX++), complete, {"action":action, "mark":mark } );
			}
		}
		
		private function complete(e:LoadEvent):void
		{
			var index:int = vector.indexOf(e.url);
			if (index != -1) vector.splice(index, 1);
			if (e.eventType == LoadEvent.ERROR) return;
			FrameWork.app.share(e.url, e.target as Loader);
			var action:IMplantation = e.data["action"] as IMplantation;
			if (!this._isvalid) return;			//下载完成后失效不回调
			action.adaptFor(e.data["mark"], this);		//下载完成资源，通知渲染
		}
		
		//添加动作
		public function addAction(actionName:String,vector:Vector.<BitmapData>):void
		{
			if (vector.length == 0) return;
			if (actionHash.isKey(actionName)) throw Error('存在的动作');
			actionHash.put(actionName, vector);
		}
		
		public function getActions(actionName:String):Vector.<BitmapData>
		{
			return actionHash.getValue(actionName);
		}
		
		public function hasAction(actionName:String):Boolean
		{
			return actionHash.isKey(actionName);
		}
		
		override public function free():void 
		{
			if (isValid()) {
				super.free();
				actionHash.eachValue(eachVector);
				actionHash.clear();
			}
			//删除所有相关下载
			/*
			for each(var url:String in vector) {
				PerfectLoader.gets().removeMark(url);
			}*/
		}
		
		private function eachVector(data:Object):void
		{
			var vector:Vector.<BitmapData> = data as Vector.<BitmapData>;
			var bit:BitmapData;
			while (vector.length) {
				bit = vector.shift();
				if(bit) bit.dispose();
			}
		}
		//ends
	}

}