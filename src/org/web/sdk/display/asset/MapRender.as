package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import org.web.sdk.global.HashMap;
	//按钮方式,或者开关方式
	/*
	 * 为了不必要的new
	 * Starling,可以使用Starling建立
	 * 
	 * */
	public class MapRender extends LibRender 
	{
		private var map:HashMap;
		
		public function MapRender(btnName:String, hash:HashMap = null, $lock:Boolean = false) 
		{
			this.map = hash;
			super(btnName, $lock);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if (this.map) {
				map.eachValue(LibRender.release);
				map = null;
			}
		}
		
		//根据一个按钮名称来取
		override public function createUpdate(data:Object):* 
		{
			if (null == map) map = new HashMap;
			if (data is String) 
			{
				var chat:String = data as String;
				var bit:BitmapData = map.getValue(chat);
				if (null == bit) 
				{
					bit = AssetFactory.getTexture(chat);
					map.put(chat, bit);
				}
				return bit;
			}
			return null;
		}
		
		//end
	}

}