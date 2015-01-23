package org.web.sdk.sound 
{
	import org.web.sdk.utils.HashMap;
	public class SoundFactory 
	{
		public static const ACTION:String = "action";		
		public static const BLACK_SONG:String = "blackSong";	//单一的声音
		//
		private static const hashMap:HashMap = new HashMap;
		
		public function SoundFactory() 
		{
			
		}
		
		public static function getSound(name:String, type:String = null):Object
		{
			return null;
		}
		
		public static function play(name:String, type:String = "action", times:int = 1):void
		{
			
		}
		
		public static function playUrl(url:String, type:String = "action", times:int = 1):void
		{
			
		}
		
		//声音大小
		public static function setVolums(volum:Number = 1, type:String = null, name:String = null):void
		{
			
		}
		
		public static function stop(type:String, name:String = null):void
		{
			
		}
		
		public static function stopAll():void
		{
			
		}
		
		public static function removeAll():void
		{
			
		}
		
		public static function remove(type:String):void
		{
			
		}
		
		public static function removeByName(type:String, name:String):void
		{
			
		}
		
		public static function isSound():Boolean
		{
			return false;
		}
		
		//继续播放
		public static function play(type:String = null):void
		{
			
		}
		
		//ends
	}

}