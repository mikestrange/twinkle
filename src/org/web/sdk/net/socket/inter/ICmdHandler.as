package org.web.sdk.net.socket.inter 
{
	public interface ICmdHandler 
	{
		function register():void;
		function replace(called:Function = null):void;				//代替处理
		function handler(cmd:Number, target:Object = null):void;
		function add(notice:Function):void;
		function remove(notice:Function):Boolean;
		function empty():Boolean;
		function destroy():void;
	}
}