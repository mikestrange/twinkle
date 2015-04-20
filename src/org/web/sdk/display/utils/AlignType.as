package org.web.sdk.display.utils 
{
	import flash.display.DisplayObject;
	import org.web.sdk.interfaces.IDisplayObject;
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
		//
		private static const LIM:int = 1;
		private static const NONE:int = 0;
		
		/*
		 * 局域对齐方式，返回计算位置的方法
		 * */
		public static function getAlign(alignType:String, target:DisplayObject, rectWidth:Number, rectHeight:Number):Swapper
		{
			switch(alignType)
			{
				case AlignType.LEFT:			return setSwapper(NONE, NONE, LIM, LIM);
				case AlignType.LEFT_CENTER:		return setSwapper(NONE, rectHeight - target.height >> LIM, LIM, LIM);
				case AlignType.LEFT_BOTTOM:		return setSwapper(NONE, rectHeight - target.height, LIM, -LIM);
				case AlignType.RIGHT_CENTER:	return setSwapper(rectWidth - target.width, rectHeight - target.height >> LIM, -LIM, LIM);
				case AlignType.RIGHT:			return setSwapper(rectWidth - target.width, NONE, -LIM, LIM);
				case AlignType.CENTER:			return setSwapper(rectWidth - target.width >> LIM, rectHeight - target.height >> LIM, LIM, LIM);
				case AlignType.RIGHT_BOTTOM:	return setSwapper(rectWidth - target.width, rectHeight - target.height, -LIM, -LIM);
				case AlignType.CENTER_BOTTOM:	return setSwapper(rectWidth - target.width >> LIM,  rectHeight - target.height, LIM, -LIM);
				case AlignType.CENTER_TOP:		return setSwapper(rectWidth - target.width >> LIM, NONE, LIM, LIM);
			}
			return setSwapper(NONE, NONE, LIM, LIM);
		}
		
		private static function setSwapper(x:int, y:int, tx:int, ty:int):Swapper
		{
			return new Swapper(x, y, tx, ty);
		}
		
		/*
		 * 自身对齐方式，返回偏移量
		 * */
		public static function getSelfAlign(dis:DisplayObject, alignType:String):Point
		{
			switch(alignType)
			{
				case AlignType.LEFT:			return setPoint(NONE,NONE);
				case AlignType.LEFT_CENTER:		return setPoint(NONE, -(dis.height >> LIM));
				case AlignType.LEFT_BOTTOM:		return setPoint(NONE, -dis.height);
				case AlignType.RIGHT_CENTER:	return setPoint(-dis.width, -(dis.height >> LIM));
				case AlignType.RIGHT:			return setPoint(-dis.width, NONE);
				case AlignType.RIGHT_BOTTOM:	return setPoint(-dis.width, -dis.height);
				case AlignType.CENTER:			return setPoint(-(dis.width >> LIM), -(dis.height >> LIM));
				case AlignType.CENTER_BOTTOM:	return setPoint(-(dis.width >> LIM), -dis.height);
				case AlignType.CENTER_TOP:		return setPoint(-(dis.width >> LIM), NONE);
			}
			return setPoint(NONE, NONE);
		}
		
		protected static function setPoint(mx:Number,my:Number):Point
		{
			return new Point(mx, my);
		}
		
		/*
		//-------------------偏移方式----------------
		//放置的偏移方式
		public static const PUT_OFFSET_LEFT:String ="OFFSET_LEFT";
		public static const PUT_OFFSET_RIGHT:String ="OFFSET_RIGHT";
		public static const PUT_OFFSET_BOTTOM:String ="OFFSET_BOTTOM";
		public static const PUT_OFFSET_TOP:String ="OFFSET_TOP";
		
		//--------------分布方式--------------------------
		//整区域根据宽度均匀分布
		public static const AUTO_WIDE:String = "AUTO_WIDE";
		//整区域根据高度均匀分布
		public static const AUTO_HEIG:String = "AUTO_HEIG";
		//根据宽度间距从左边开始分布
		public static const GAP_WIDE_LEFT:String = "GAP_WIDE_LEFT";
		//根据宽度间距从左边开始分布
		public static const GAP_WIDE_RIGHT:String = "GAP_WIDE_RIGHT";
		//根据高度间距从顶部开始分布
		public static const GAP_HEIG_TOP:String = "GAP_HEIG_TOP";
		//根据高度间距从底部开始分布
		public static const GAP_HEIG_BOTTOM:String = "GAP_HEIG_BOTTOM";
		*/
		//end
	}

}