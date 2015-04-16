package org.web.sdk.display.core.stock 
{
	import org.web.sdk.admin.AlertManager;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.interfaces.rest.IAlert;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 贴士的基类，因为一般体积小，所以不延迟执行
	 */
	public class Alert extends BaseSprite implements IAlert 
	{
		private var _type:int;
		
		/* INTERFACE org.web.sdk.interfaces.rest.ITips */
		public function get type():int 
		{
			return _type;
		}
		
		public function show(type:int, data:Object):void 
		{
			_type = type;
		}
		
		public function hide():void 
		{
			this.removeFromFather(true);
		}
		
		final public function removeFromAdmin():void 
		{
			AlertManager.gets().remove(this);
		}
		
		//ends
	}

}