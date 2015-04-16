package org.web.sdk.display.paddy.build 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import org.web.sdk.AppWork;
	import org.web.sdk.display.paddy.Texture;
	import org.web.sdk.display.utils.DrawUtils;
	import org.web.sdk.global.string;
	/*
	 * 规则生成工厂
	 * */
	public class SheetPeasants 
	{
		private static const FROM_LENG:int = 4;
		
		//原始素材
		public static function getTexture(className:String, url:String = null):Texture
		{
			var item:* = AppWork.getAsset(className, url);
			if (item == null) return null;
			if (item is DisplayObject) item = DrawUtils.draw(item as DisplayObject);
			//throw Error("不知道是什么类型:"+className);
			return new Texture(item as BitmapData);
		}
		
		//根据一个泛型类，注入替换字符,不会被存入
		public static function fromVector(formName:String, url:String = null):Vector.<Texture>
		{
			var index:int = 0;
			var list:Vector.<Texture> = new Vector.<Texture>;
			var tex:Texture;
			while (++index)
			{
				tex = getTexture(string.format(formName, string.formatNumber(index, FROM_LENG)), url);
				if (tex == null) break;
				list.push(tex);
			}
			if (list.length == 0) return null;
			return list;
		}
		
		/*
		//直接生成资源
		public static function by_class(className:String):LibRender
		{
			var item:* = AppWork.getAsset(className, null);
			if (item is BitmapData) return new BaseRender(className, item as BitmapData);
			if (item is DisplayObject) return new BaseRender(className, DrawUtils.draw(item as DisplayObject));
			throw Error("不知道是什么类型:"+className);
			return null;
		}
		
		//根据一个动画生成素材链
		private static function by_movie(movie:MovieClip):Vector.<BitmapData>
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
		public static function fromMovie(className:String, url:String = null):MovieRender
		{
			var item:* =  AppWork.getAsset(className, url);
			if (item is MovieClip) {
				if (MovieClip(item).totalFrames == 1) throw Error("这个动画图像只有一帧，没必要用影片剪辑的形式：" + className);
				return new MovieRender(className, by_movie(item));
			}
			throw Error("改对象不是影片剪辑类：" + className);
			return null;
		}
		*/
		//ends
	}

}