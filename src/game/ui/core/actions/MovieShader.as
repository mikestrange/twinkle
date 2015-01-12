package game.ui.core.actions 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import org.web.sdk.FrameWork;
	import org.web.sdk.gpu.shader.CryRenderer;
	import org.web.sdk.gpu.texture.VRayTexture;
	import org.web.sdk.inters.IEscape;
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
		public function load(url:String, action:IEscape):void
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
			render("render", e.data as IEscape, e.url);
		}
		
		override public function render(type:String, action:IEscape, data:Object = null):void 
		{
			switch(type)
			{
				case "load":
					load(data as String, action);
				break;
				default:
					var name:String = GpuMovie(action).currentName;
					if (!hasAction(name)) {
						trace(data)
						addAction(name, VRayTexture.fromVector(name+".png", "%d", -1, data as String));
						//VRayTexture.fromVector(name,getActionName(name))
						//addAction(name, getActionVectors(name, data as String));
					}
					//直接渲染
					action.updateRender(getCode(), getActions(name));
				break;
			}
		}
		
		//添加动作
		protected function addAction(action:String, vector:Vector.<VRayTexture>):void
		{
			if (vector.length == 0) return;
			if (actionHash.isKey(action)) throw Error('存在的动作');
			actionHash.put(action, vector);
		}
		
		protected function getActions(action:String):Vector.<VRayTexture>
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
			var vector:Vector.<VRayTexture> = data as Vector.<VRayTexture>;
			var texture:VRayTexture;
			while (vector.length) {
				texture = vector.shift();
				if(texture) texture.dispose();
			}
		}
		
		public static function getActionName(action:String, point:int = 0):String
		{
			return action.replace("%s", point);
		}
		//ends
	}

}