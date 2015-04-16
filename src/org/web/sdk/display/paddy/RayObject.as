package org.web.sdk.display.paddy 
{
	import org.web.sdk.display.paddy.interfaces.IRender;
	import org.web.sdk.display.paddy.build.SheetPeasants;
	import org.web.sdk.display.paddy.covert.FormatMethod;
	import org.web.sdk.display.paddy.covert.SmartRender;
	import org.web.sdk.display.paddy.covert.TexturePacker;
	/**
	 * 速度更快的显示对象，基于bitmapdata
	 */
	public class RayObject extends MapSheet implements IRender
	{
		public static const AUTO:String = "auto";
		//渲染器
		private var _res:SmartRender;
		
		public function RayObject(res:SmartRender = null) 
		{
			if(res) setBufferRender(res);
		}
		
		//强制获取资源
		protected function refreshRender(data:FormatMethod = null):void
		{
			if (isRender()) _res.setting(this, data);
		}
		
		//不一定设置名称给他自己,上面会设置 ,默认是一个类名,你可以修改
		protected function getNewRender(data:FormatMethod):SmartRender
		{
			const tx:Texture = SheetPeasants.getTexture(data.getFormat(), data.getNamespace());
			if (tx) return new TexturePacker(data.getResName(), tx);
			return null;
		}
		
		/* INTERFACE org.web.sdk.interfaces.IRender */
		override public function dispose():void 
		{
			super.dispose();
			if (_res) {
				_res.relieve();
				_res = null;
			}
		}
		
		// 切换材质的时候，如果前一个是弱引用，那么就会被清理
		final public function setBufferRender(res:SmartRender, data:FormatMethod = null):void
		{
			if (_res == res) {
				refreshRender(data);
			}else {
				if (_res) _res.relieve();
				_res = res;
				if (_res) _res.setting(this, data);
			}
		}
		
		public function setResource(resName:String):Boolean
		{
			if (SmartRender.asset.hasRes(resName))
			{
				this.setBufferRender(SmartRender.asset.getResource(resName));
				return true;
			}
			return false;
		}
		
		//强制,并且生成资源
		public function setCompulsory(format:String, namespaces:String = null, type:int = 0):void
		{
			const att:FormatMethod = new FormatMethod(format, namespaces, type);
			if (SmartRender.asset.hasRes(att.getResName())) {
				setBufferRender(SmartRender.asset.getResource(att.getResName()), att);
			}else {
				const asset:SmartRender = getNewRender(att);
				if (asset) setBufferRender(asset, att);
			}
		}
		
		//捕获到的资源
		public function retakeTarget(data:Object):void
		{
			if (data is Texture) setTexture(data as Texture);
		}
		
		public function clone():IRender 
		{
			return new RayObject(_res);
		}
		
		public function getResource():SmartRender
		{
			return _res;
		}
		
		public function isRender():Boolean
		{
			return _res != null;
		}
		
		/*
		//static 
		public static function format(wide:int, high:int, color:uint = 0):RayObject
		{
			const names:String = "bit:w" + wide + "h" + high + "c" + color;
			const ray:RayObject = new RayObject;
			//默认情况不会创建
			if (!ray.setResource(names)) 
			{
				ray.setBufferRender(new BaseRender(names, new Texture(new BitmapData(wide, high, true, color))));
			}
			return ray;
		}
		*/
		//ends
	}
}