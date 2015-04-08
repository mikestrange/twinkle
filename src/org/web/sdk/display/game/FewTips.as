package org.web.sdk.display.game 
{
	import org.web.sdk.admin.TipsManager;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.interfaces.rest.ITips;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 贴士的基类，因为一般体积小，所以不延迟执行
	 */
	public class FewTips extends BaseSprite implements ITips 
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
			this.removeFromFather();
			this.finality();
		}
		
		final public function removeFromAdmin():void 
		{
			TipsManager.gets().remove(this);
		}
		
		//ends
	}

}