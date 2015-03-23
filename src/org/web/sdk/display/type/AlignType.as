package org.web.sdk.display.type 
{
	import org.web.sdk.display.utils.Swapper;
	
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
		
		//返回的是一个偏移量
		public static function obtainReposition(targetlimitWidth:Number, targetlimitHeight:Number, limitWidth:Number, limitHeight:Number, alignType:String):Swapper
		{
			const pos:Swapper = new Swapper;
			switch(alignType)
			{
				case AlignType.LEFT:
					break;
				case AlignType.LEFT_CENTER:
						pos.y = (limitHeight - targetlimitHeight) / 2;
						pos.setTrend(1, 1);
					break;
				case AlignType.LEFT_BOTTOM:
						pos.y = limitHeight - targetlimitHeight;
						pos.setTrend(1, -1);
					break;
				case AlignType.RIGHT_CENTER:
						pos.x = limitWidth - targetlimitWidth;
						pos.y = (limitHeight - targetlimitHeight) / 2;
						pos.setTrend(-1, 1);
					break;
				case AlignType.RIGHT:
						pos.x = limitWidth - targetlimitWidth;
						pos.setTrend(-1, 1);
					break;
				case AlignType.CENTER:
						pos.x = (limitWidth - targetlimitWidth) / 2;
						pos.y = (limitHeight - targetlimitHeight) / 2;
						pos.setTrend(1, 1);
					break;
				case AlignType.RIGHT_BOTTOM:
						pos.x = limitWidth - targetlimitWidth;
						pos.y = limitHeight - targetlimitHeight;
						pos.setTrend(-1, -1);
					break;
				case AlignType.CENTER_BOTTOM:
						pos.x = (limitWidth - targetlimitWidth) / 2;
						pos.y = limitHeight - targetlimitHeight;
						pos.setTrend(1, -1);
					break;
				case AlignType.CENTER_TOP:
						pos.x = (limitWidth - targetlimitWidth) / 2;
						pos.setTrend(1, 1);
					break;
			}
			return pos;
		}
		
		
		//end
	}

}