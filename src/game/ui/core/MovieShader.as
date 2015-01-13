package game.ui.core 
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import game.ui.core.GpuCustom;
	import org.alg.utils.MapPath;
	import org.web.sdk.FrameWork;
	import org.web.sdk.gpu.shader.CryRenderer;
	import org.web.sdk.gpu.texture.VRayTexture;
	import org.web.sdk.inters.IEscape;
	import org.web.sdk.load.LoadEvent;
	import org.web.sdk.utils.HashMap;
	
	/*
	 *通过不同的动作下载不同，下载不被删除,可以选择一个替代品 
	 * */
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
		
		override public function render(type:String, display:IEscape, data:Object = null):void 
		{
			var url:String = loadAction(data as String);
			if (!FrameWork.app.has(url)) {
				FrameWork.app.load(url, complete, display);
				return;	//这里可以给他默认渲染
			}
			var name:String = GpuCustom(display).currentName;
			if (!hasAction(name)) addAction(name, VRayTexture.fromVector(name + ".png", "%d", -1, url));
			//直接渲染
			display.updateRender(getCode(), getActions(name));
		}
		
		//根据不同的动作和type取url
		protected function loadAction(action:String):String
		{
			return MapPath.ROOT_URL + "ui/001_player.swf";
		}
		
		//加载完成后继续渲染
		private function complete(e:LoadEvent):void
		{
			if (e.eventType == LoadEvent.ERROR) return;
			FrameWork.app.share(e.url, e.target as Loader);
			if (!isValid()) return;
			render("render", e.data as IEscape, e.url);
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
		
		//释放资源
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
		//ends
	}

}