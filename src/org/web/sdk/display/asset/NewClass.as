package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import org.web.sdk.utils.DrawUtils;
	import flash.utils.getDefinitionByName;
	
	public class NewClass 
	{
		
		//***这里获取的都是本地资源
		public static function createByClass(className:String):LibRender
		{
			var classNode:Class = getDefinitionByName(className) as Class;
			var item:* = new classNode;
			if (item is BitmapData) return new SingleTexture(item, className);
			if (item is DisplayObject) return new SingleTexture(DrawUtils.draw(item), className);
			throw Error("不知道是什么类型:"+className);
		}
		
		//如果动画下面还有动画，那没得搞
		public static function cloneMovie(movie:MovieClip):Vector.<BitmapData>
		{
			var vector:Vector.<BitmapData> = new Vector.<BitmapData>;
			var bit:BitmapData;
			movie.stop();
			for (var i:int = 1; i <= movie.totalFrames; i++) {
				bit = DrawUtils.draw(movie);
				vector.push(bit);
				movie.gotoAndStop(i);
			}
			return vector;
		}
		
		//构造动画
		public static function createMovie(className:String):VectorTexture
		{
			var classNode:Class = getDefinitionByName(className) as Class;
			var item:* = new classNode;
			if (item is MovieClip) {
				if (MovieClip(item).totalFrames == 1) throw Error("这个动画图像只有一帧，没必要用影片剪辑的形式：" + className);
				return new VectorTexture(cloneMovie(item), className);
			}
			throw Error("改对象不是影片剪辑类：" + className);
			return null;
		}
		//ends
	}

}