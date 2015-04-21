package org.web.sdk.display.effect 
{
	import com.greensock.TweenLite;
	import org.web.sdk.AppWork;
	import org.web.sdk.interfaces.IDisplayObject;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 * 窗口呈现的一些效果
	 */
	final public class DisplayEffects 
	{
		private static const LIM:int = 1;
		
		//扩散效果，释放效果的时候，隐藏会可见
		public static function pervasion(target:IDisplayObject, scale:Number = .8, time:Number = .1, complete:Function = null):void
		{
			//屏幕中间
			var endx:int = AppWork.stageWidth - target.sizeWidth >> 1;
			var endy:int = AppWork.stageHeight - target.sizeHeight >> 1;
			//拉伸裁剪尺寸
			var endwide:int = target.sizeWidth * ((LIM - scale) / 2);
			var endheig:int = target.sizeHeight * ((LIM - scale) / 2);
			//初始设置
			target.moveTo(endx + endwide, endy + endheig);
			target.setRatio(scale);
			//扩散
			TweenLite.to(target, time, { alpha:LIM, x:endx, y:endy, scaleX:LIM, scaleY:LIM, onComplete:complete } );
		}
		
		//就当前关闭
		public static function shutting(target:IDisplayObject, scale:Number = .8, time:Number = .1, complete:Function = null):void
		{
			//拉伸裁剪尺寸
			var cut_wide:int = target.sizeWidth * ((LIM - scale) / 2);
			var cut_heig:int = target.sizeHeight * ((LIM - scale) / 2);
			//结束位置
			var endx:int = target.x + cut_wide;
			var endy:int = target.y + cut_heig;
			//扩散
			TweenLite.to(target, time, { x:endx, y:endy, scaleX:scale, scaleY:scale, onComplete:complete } );
		}
			
		//飞向屏幕中间
		public static function flyfrom(target:IDisplayObject, startx:int = 0, starty:int = 0, scale:Number = .2, time:Number = .2, complete:Function = null):void
		{
			//飞向屏幕中间
			var endx:int = AppWork.stageWidth - target.sizeWidth >> 1;
			var endy:int = AppWork.stageHeight - target.sizeHeight >> 1;
			//初始设置
			target.moveTo(startx, starty);
			target.setRatio(scale);
			//扩散
			TweenLite.to(target, time, { alpha:LIM, x:endx, y:endy, scaleX:LIM, scaleY:LIM, onComplete:complete } );
		}
		
		//ends
	}

}