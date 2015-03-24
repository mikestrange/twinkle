package org.web.sdk.display.utils 
{
	import flash.filters.GlowFilter;
	import org.web.sdk.display.Multiple;
	import org.web.sdk.display.asset.KitBitmap;
	import org.web.sdk.display.text.TextEditor;
	import flash.display.*;
	import flash.geom.*;
	/*
	 * 回执
	 * */
	public class DrawUtils 
	{
		
		
		//绘制对象					绘制的对象			一个偏移量					
		public static function draw(dis:DisplayObject, setrect:Rectangle = null):BitmapData 
		{
			var rect:Rectangle = setrect == null ? dis.getBounds(dis) : setrect;
			var bitmapdata:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			bitmapdata.draw(dis, new Matrix(1, 0, 0, 1, -rect.x, -rect.y), null, null, null, true);
			return bitmapdata;
		}
		
		//文本转换
		private static const text:TextEditor = new TextEditor;
		public static function drawEditor(name:String, color:uint = 0xff0000, font:String = "大宋"):KitBitmap
		{
			text.finality();
			text.filters = [new GlowFilter(0, 1, 2, 2, 5, 2)];
			text.addText(name, false, color, -1, font);
			return new KitBitmap(draw(text));
		}
		
		//ends
	}

}