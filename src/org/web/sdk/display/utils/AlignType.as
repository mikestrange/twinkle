package org.web.sdk.display.utils 
{
	import flash.display.DisplayObject;
	import org.web.sdk.interfaces.IDisplay;
	import flash.geom.Point;
	
	public class AlignType 
	{
		//---------------------对齐方式---------------------
		//对齐方式
		public static const LEFT:String = "left";						//左对齐		
		public static const LEFT_CENTER:String = "left_center";			//左居中对齐
		public static const LEFT_BOTTOM:String = "left_bottom";			//左底对齐
		public static const RIGHT_CENTER:String = "right_center";		//右居中对齐
		public static const RIGHT:String = "right";						//右对齐
		public static const CENTER:String = "center";					//居中对齐
		public static const RIGHT_BOTTOM:String = "right_bottom";		//右底部
		public static const CENTER_BOTTOM:String = "center_bottom";		//中间底部
		public static const CENTER_TOP:String = "center_top";			//中间顶部
		
		/*
		 * 局域对齐方式，返回计算位置的方法
		 * */
		public static function obtainReposition(alignType:String, target:DisplayObject, rectWidth:Number, rectHeight:Number):Swapper
		{
			switch(alignType)
			{
				case AlignType.LEFT:			return setSwapper(0, 0, 1, 1);
				case AlignType.LEFT_CENTER:		return setSwapper(0, rectHeight - target.height >> 1, 1, 1);
				case AlignType.LEFT_BOTTOM:		return setSwapper(0, rectHeight - target.height, 1, -1);
				case AlignType.RIGHT_CENTER:	return setSwapper(rectWidth - target.width, rectHeight - target.height >> 1, -1, 1);
				case AlignType.RIGHT:			return setSwapper(rectWidth - target.width, 0, -1, 1);
				case AlignType.CENTER:			return setSwapper(rectWidth - target.width >> 1, rectHeight - target.height >> 1, 1, 1);
				case AlignType.RIGHT_BOTTOM:	return setSwapper(rectWidth - target.width, rectHeight - target.height, -1, -1);
				case AlignType.CENTER_BOTTOM:	return setSwapper(rectWidth - target.width >> 1,  rectHeight - target.height, 1, -1);
				case AlignType.CENTER_TOP:		return setSwapper(rectWidth - target.width >> 1, 0, 1, 1);
			}
			return setSwapper(0, 0, 1, 1);
		}
		
		private static function setSwapper(x:int, y:int, tx:int, ty:int):Swapper
		{
			return new Swapper(x, y, tx, ty);
		}
		
		/*
		 * 自身对齐方式，返回偏移量
		 * */
		public static function selfObtainReposition(dis:DisplayObject, alignType:String, offx:int = 0, offy:int = 0):Point
		{
			switch(alignType)
			{
				case AlignType.LEFT:			return setPoint(offx, offy);
				case AlignType.LEFT_CENTER:		return setPoint(offx, -(dis.height >> 1) + offy);
				case AlignType.LEFT_BOTTOM:		return setPoint(offx, -dis.height + offy);
				case AlignType.RIGHT_CENTER:	return setPoint(-dis.width + offx, -(dis.height >> 1) + offy);
				case AlignType.RIGHT:			return setPoint(-dis.width + offx, offy);
				case AlignType.RIGHT_BOTTOM:	return setPoint(-dis.width + offx, -dis.height + offy);
				case AlignType.CENTER:			return setPoint(-(dis.width >> 1) + offx, -(dis.height >> 1) + offy);
				case AlignType.CENTER_BOTTOM:	return setPoint(-(dis.width >> 1) + offx, -dis.height + offy);
				case AlignType.CENTER_TOP:		return setPoint(-(dis.width >> 1) + offx, offy);
			}
			return setPoint(offx, offy);
		}
		
		protected static function setPoint(mx:Number,my:Number):Point
		{
			return new Point(mx, my);
		}
		//end
	}

}