package org.web.sdk.display.asset 
{
	import flash.display.BitmapData;
	import org.web.sdk.utils.HashMap;
	//按钮方式,或者开关方式
	public class KitButton extends LibRender 
	{
		private var map:HashMap;
		
		public function KitButton(btnName:String = null, $lock:Boolean = false) 
		{
			map = new HashMap;
			super(btnName, $lock);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			map.eachValue(LibRender.release);
			map = new HashMap;
		}
		
		//根据一个按钮名称来取
		override public function update(data:Object):* 
		{
			if (data is String) {
				var chat:String = data as String;
				if (map.isKey(chat)) {
					return map.getValue(chat);
				}else {
					var bit:BitmapData = KitFactory.getTexture(chat);
					map.put(chat, bit);
					return bit;
				}
			}
			return null;
		}
		
		//end
	}

}