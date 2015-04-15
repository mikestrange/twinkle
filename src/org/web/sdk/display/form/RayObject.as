package org.web.sdk.display.form 
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import org.web.sdk.display.form.lib.BaseRender;
	import org.web.sdk.display.form.rule.RuleFactory;
	import org.web.sdk.interfaces.IDisplay;
	import org.web.sdk.display.form.lib.AttainMethod;
	import org.web.sdk.display.form.interfaces.IRender;
	import org.web.sdk.display.form.lib.ResRender;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.display.utils.Swapper;
	import org.web.sdk.AppWork;
	import flash.geom.Point;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	/**
	 * 速度更快的显示对象，基于bitmapdata
	 */
	public class RayObject extends BaseSheet implements IRender
	{
		public static const AUTO:String = "auto";
		//渲染器
		private var _res:ResRender;
		
		public function RayObject(res:ResRender = null) 
		{
			if(res) setBufferRender(res);
		}
		
		//强制获取资源
		protected function refreshRender(data:AttainMethod = null):void
		{
			if (isRender()) _res.setting(this);
		}
		
		//不一定设置名称给他自己,上面会设置 ,默认是一个类名,你可以修改
		protected function getNewRender(data:AttainMethod):ResRender
		{
			const tx:Texture = RuleFactory.getTexture(data.getFormat(), data.getNamespace());
			if (tx) return new BaseRender(data.getResName(), tx);
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
		final public function setBufferRender(res:ResRender, data:AttainMethod = null):void
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
			if (ResRender.asset.hasRes(resName))
			{
				this.setBufferRender(ResRender.asset.getResource(resName));
				return true;
			}
			return false;
		}
		
		//强制,并且生成资源
		public function setCompulsory(format:String, namespaces:String = null, type:int = 0):void
		{
			const att:AttainMethod = new AttainMethod(format, namespaces, type);
			if (ResRender.asset.hasRes(att.getResName())) {
				setBufferRender(ResRender.asset.getResource(att.getResName()), att);
			}else {
				const asset:ResRender = getNewRender(att);
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
		
		public function getResource():ResRender
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