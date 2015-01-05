package org.web.sdk.display 
{
	import flash.display.*;
	import flash.geom.*;
	import flash.net.LocalConnection;
	import org.web.sdk.display.core.Image;
	import org.web.sdk.display.core.BoneSprite;
	import org.web.sdk.display.inters.IBitmap;
	import org.web.sdk.display.inters.ISprite;
	
	public class Multiple 
	{
		public static const RECT:Rectangle = new Rectangle;
		public static const COLOR_TRANS_FORM:ColorTransform = new ColorTransform;
		public static const MATRIX:Matrix = new Matrix;
		
		//释放元素子集
		public static function wipeout(dis:DisplayObjectContainer, dispose:Boolean = true):void
		{
			if (null == dis) return;
			var item:DisplayObject;
			while (dis.numChildren) {
				item = dis.removeChildAt(0);
				if (item is ISprite) ISprite(item).finality(dispose);
				else if (item is IBitmap) IBitmap(item).dispose();
				else if (item is Sprite) wipeout(Sprite(item));
				//
				if (item is MovieClip) MovieClip(item).stop();
				if (dispose) {
					if (item is Loader) Loader(item).unloadAndStop();
				}
			}
		}
		
		//初始化一个dis   不改变显示状态
		public static function initNaturo(dis:DisplayObject):DisplayObject
		{
			if (dis is MovieClip) MovieClip(dis).gotoAndStop(1);
			//dis.visible = true;
			dis.cacheAsBitmap = false;
			dis.mask = null;
			dis.rotation = 0;
			dis.alpha = 1;
			dis.scaleX = dis.scaleY = 1;
			dis.x = dis.y = 0;
			dis.filters = [];
			dis.transform.colorTransform = COLOR_TRANS_FORM;
			dis.transform.matrix = MATRIX;
			return dis;
		}
		
		//强制回收
		public static function collection(count:uint = 2) : void
        {
			var connent:LocalConnection = null;
			for (var i:int = 0; i < count; i++) {
				connent = new LocalConnection();
				try {
					connent.connect("deleteName_King");
				}catch (e:Error) {
					trace('#Error:强制清理');
				}
			}
        }
		
		//绘制对象					绘制的对象			一个偏移量					
		public static function draw(dis:DisplayObject, setrect:Rectangle = null):BitmapData 
		{
			var rect:Rectangle = setrect == null ? dis.getBounds(dis) : setrect;
			var bitmapdata:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			bitmapdata.draw(dis, new Matrix(1, 0, 0, 1, -rect.x, -rect.y), null, null, null, true);
			return bitmapdata;
		}
		//ends
	}

}