package org.web.sdk.display.base 
{
	import org.web.sdk.admin.PopupManager;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.global.tool.Ticker;
	import org.web.sdk.interfaces.rest.IWindow;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 窗口
	 */
	public class GamePanel extends BaseSprite implements IWindow 
	{
		/* INTERFACE org.web.sdk.interfaces.rest.IPanel */
		public function getDefineName():String
		{
			return null;
		}
		
		public function show(data:Object = null):void
		{
			
		}
		
		public function update(data:Object):void 
		{
			
		}
		
		//这里注入true
		public function closed():void 
		{
			this.unRegister();
			removeFromFather(true);
		}
		
		//close 中允许做其他操作
		final protected function unRegister():void
		{
			PopupManager.unRegister(this);
		}
		
		/*
		protected function delayRender(delay:int, ...rests):void
		{
			for (var i:int = 0; i < rests.length; i++) 
			{
				Ticker.step(delay * i, delayHandler, Ticker.ONCE, rests[i]);
			}
		}
		
		private function delayHandler(handler:Function):void
		{
			if(handler is Function) handler();
		}
		*/
		//end
	}

}