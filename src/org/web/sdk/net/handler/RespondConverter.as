package org.web.sdk.net.handler 
{
	import flash.utils.Dictionary;
	import org.web.sdk.net.handler.RespondEvented;
	import org.web.sdk.net.interfaces.IConverter;
	import org.web.sdk.net.interfaces.INetHandler;
	import org.web.sdk.system.events.Evented;
	import org.web.sdk.utils.UniqueHash;
	
	/*
	 * 处理命令的转换器，基类
	 * */
	public class RespondConverter implements IConverter 
	{
		private var isregister:Boolean = false;
		
		public function register():void
		{
			if (isregister) return;
			isregister = true;
			var arr:Array = getCmdList();
			for (var i:int; i < arr.length; i++) registerHandler(arr[i], actionHandler);
		}
		
		public function getCmdList():Array
		{
			return null;
		}
		
		protected function actionHandler(event:RespondEvented):void
		{
			
		}
		
		public function registerHandler(cmd:Number, called:Function):void
		{
			CmdManager.cmdHanlder(cmd, called, this);
		}
		
		public function removeHandler(cmd:Number, called:Function):void
		{
			CmdManager.removeHandler(cmd, called, this);
		}
		
		public function destroy():void
		{
			if (isregister) {
				isregister = false;
				var arr:Array = getCmdList();
				for (var i:int; i < arr.length; i++) removeHandler(arr[i], actionHandler);
			}
		}
		//ends
	}

}