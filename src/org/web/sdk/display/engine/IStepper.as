package org.web.sdk.display.engine 
{
	
	public interface IStepper 
	{
		//启动离子
		function run():void;
		//检测类容
		function step(event:Object):void;
		//终止  在终止的时候要移除直接kill
		function die():void;
		//ends
	}
}