package org.web.sdk.display.utils 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import org.web.sdk.interfaces.IBaseSprite;
	/**
	 * ...
	 * @author Mike email:542540443@qq.com
	 */
	final public class SortSprite 
	{
		//层级排序
		public static function sort(roots:IBaseSprite):void
		{
			var list:Array = roots.getChildren();
			if (list == null || list.length < 2) return;
			list.sortOn("y", Array.NUMERIC);
			var dis:DisplayObject;
			var sprite:Sprite = roots.convertSprite();
			for (var floor:int  = 0; floor < list.length; floor++) 
			{
				dis = list[floor];
				if (sprite.getChildIndex(dis) != floor) 
				{
					sprite.setChildIndex(dis, floor);
				}
			}
		}
		
		//ends
	}

}