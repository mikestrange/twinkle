package org.web.sdk.display.core.stock 
{
	import org.web.sdk.admin.WinManager;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.global.tool.Ticker;
	import org.web.sdk.interfaces.rest.IPanel;
	
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 窗口
	 */
	public class GamePanel extends BaseSprite implements IPanel 
	{
		private var _name:String;
		
		/* INTERFACE org.web.sdk.interfaces.rest.IPanel */
		public function getPanelName():String
		{
			return _name;
		}
		
		public function onEnter(name:String, data:Object):void
		{
			_name = name;
		}
		
		//提供一个延迟渲染
		public function delayRender(delay:int, ...rests):void
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
		
		//自身不调用
		public function onExit(value:Boolean = true):void 
		{
			Ticker.kill(delayHandler, true);
			this.removeFromFather();
			this.finality();
		}
		
		public function update(data:Object):void 
		{
			
		}
		
		//内存中删除后，然后从舞台移除对象
		final public function removeFromAdmin():void 
		{
			WinManager.exit(_name, false);
		}
		
		//end
	}

}