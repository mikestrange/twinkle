package org.web.sdk.display.core 
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.*;
	import flash.net.LocalConnection;
	import org.web.sdk.interfaces.*;
	import org.web.sdk.log.Log;
	
	public class KitTool 
	{
		public static const RECT:Rectangle = new Rectangle;
		public static const COLOR_TRANS_FORM:ColorTransform = new ColorTransform;
		public static const MATRIX:Matrix = new Matrix;
		
		//释放元素子集
		public static function wipeout(dis:DisplayObjectContainer, value:Boolean = true):void
		{
			if (null == dis) return;
			var item:DisplayObject;
			while (dis.numChildren) {
				item = dis.removeChildAt(0);
				if (item is IDisplay) IDisplay(item).finality(value);
				else if (item is Sprite) wipeout(Sprite(item));
				//
				if (item is MovieClip) MovieClip(item).stop();
				if (value && (item is Loader)) Loader(item).unloadAndStop();
			}
		}
		
		public static function removeForParent(dis:DisplayObject):void
		{
			if (dis.parent) dis.parent.removeChild(dis);
		}
		
		//初始化一个dis   
		public static function initNaturo(dis:DisplayObject):DisplayObject
		{
			if (dis is MovieClip) MovieClip(dis).gotoAndStop(1);
			dis.visible = true;
			dis.cacheAsBitmap = false;
			dis.transform.colorTransform = COLOR_TRANS_FORM;
			dis.transform.matrix = MATRIX;
			dis.mask = null;
			dis.rotation = 0;
			dis.alpha = 1;
			dis.scaleX = dis.scaleY = 1;
			dis.x = dis.y = 0;
			dis.filters = [];
			return dis;
		}
		
		//释放位图
		public static function dispose(bit:BitmapData):void
		{
			if (bit && bit.width + bit.height > 0) bit.dispose();
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
					Log.log().debug('#Error:强制清理');
				}
			}
        }
		//ends
	}

}