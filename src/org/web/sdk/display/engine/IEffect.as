package org.web.sdk.display.engine 
{
	import org.web.sdk.display.engine.IStepper;
	
	/*
	 * 特效或者动画之类
	 * */
	public interface IEffect extends IStepper 
	{			
		/*
		 * 添加到引擎延迟的时间,0表示下一帧 ,其实已经被添加进去了，不过没有表现而已
		 * */
		function play(body:Object = null, delay:Number = -1):void;
		/*
		 * 因为不可能在某个时刻记录所有的促发效果,没有意义
		 * 下一个特效,意味某个时间会促发下一个特效
		 * */
		function next():IEffect;
		/*
		 * 上一个特效,如果没有上一个，那么null
		 * */
		function prev():IEffect;			
		/*
		 * 至于你促发哪个，完全你控制
		 * */
		function touch(type:int = 0):void;					
		//ends
	}
	
}