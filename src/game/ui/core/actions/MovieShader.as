package game.ui.core.actions 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import org.web.sdk.FrameWork;
	import org.web.sdk.inters.IMutation;
	import org.web.sdk.gpu.asset.CryRenderer;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.utils.HashMap;
	
	//动态库，大部分相同的保存在同一库下,这里必须做一个标记，下载过的标记
	public class MovieShader extends CryRenderer 
	{
		private static var INDEX:int = 0;
		//
		private var actionHash:HashMap;
		
		public function MovieShader(key:String) 
		{
			super(key);
		}
		
		override protected function initialization(value:Boolean):void 
		{
			if (value) actionHash = new HashMap;
		}
		
		//动态渲染
		public function load(url:String,action:IMutation):void
		{
			if (FrameWork.app.has(url)) {
				render("render", action);
			}else {
				FrameWork.downLoad(url, LoadEvent.SWF, complete, action);
			}
		}
		
		private function complete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) return;
			FrameWork.app.share(e.url, e.target as Loader);
			if (!isValid()) return;
			render("render", e.data as IMutation,e.url);
		}
		
		override public function render(type:String, action:IMutation, data:Object = null):void 
		{
			switch(type)
			{
				case "load":
					load(data as String, action);
				break;
				default:
					var name:String = GpuMovie(action).currentName;
					if (!hasAction(name)) addAction(name, getActionVectors(name, data as String));
					//直接渲染
					action.updateRender(getCode(), getActions(name));
				break;
			}
		}
		
		//添加动作
		protected function addAction(action:String, vector:Vector.<BitmapData>):void
		{
			if (vector.length == 0) return;
			if (actionHash.isKey(action)) throw Error('存在的动作');
			actionHash.put(action, vector);
		}
		
		protected function getActions(action:String):Vector.<BitmapData>
		{
			return actionHash.getValue(action);
		}
		
		protected function hasAction(action:String):Boolean
		{
			return actionHash.isKey(action);
		}
		
		override public function free():void 
		{
			if (isValid()) {
				super.free();
				actionHash.eachValue(eachVector);
				actionHash.clear();
			}
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
		
		
		//********************************
		public static function getActionName(action:String, point:int = 0):String
		{
			return action.replace("%s", point);
		}
		
		//取动作列表
		public static function getTextures(name:String, start:int = 1, len:int = int.MAX_VALUE, url:String = null):Vector.<BitmapData>
		{
			var vector:Vector.<BitmapData> = new Vector.<BitmapData>;
			var index:int = start;
			var bit:BitmapData;
			while (true) {
				bit = FrameWork.getAsset(name + index + ".png", url) as BitmapData;
				index++;
				if (index > len) break;
				if (bit) vector.push(bit);
				else break;
			}
			return vector;
		}
		
		//根据角色和方向取动作
		public static function getActionVectors(name:String, url:String = null):Vector.<BitmapData>
		{
			return getTextures(name, 1, int.MAX_VALUE, url);
		}
		//ends
	}

}