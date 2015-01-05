package org.web.sdk.sound  
{
	import org.web.sdk.sound.core.ISound;
	
	public class SoundData
	{
		private var soundList:Vector.<ISound>;
		private var _repeat:Boolean;		//重复
		private var _single:Boolean;		//是否只允许一个
		private var _type:int;				//类型
		
		public function SoundData(type:int, repeat:Boolean, single:Boolean)
		{
			soundList = new Vector.<ISound>;
			_type = type;
			_repeat = repeat;
			_single = single;
		}
		
		public function add(sound:ISound):ISound
		{
			if (_single && soundList.length) {
				var song:ISound = soundList.shift();
				song.free();
			}
			soundList.push(sound);
			return sound;
		}
		
		//关闭声音[遍历所有]
		public function removeByName(name:String, all:Boolean = true):void
		{
			for (var i:int = soundList.length - 1; i >= 0; i--) {
				if (soundList[i].name == name) {
					soundList[i].free();
					soundList.splice(i, 1);
					if (!all) break;
				}
			}
		}
		
		public function getByName(name:String):ISound
		{
			var song:ISound;
			for each(song in soundList) {
				if (song.name == name) return song;
			}
			return null;
		}
		
		public function stopAll():void
		{
			var song:ISound;
			for each(song in soundList) song.stop();
		}
		
		public function playAll():void
		{
			var song:ISound;
			for each(song in soundList) song.play(song.pointer);
		}
		
		//移除并且关闭所有
		public function removeAndCloseAll():void
		{
			while (soundList.length) soundList.shift().free();
		}
		
		//所有值执行 rest[0] 第一个参数会被song替代,所以传的时候传null
		public function eachValue(called:Function, ...rest):void
		{
			var song:ISound;
			for each(song in soundList) {
				rest[0] = song;
				called.apply(null, rest);
			}
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get single():Boolean
		{
			return _single;
		}
		
		public function get repeat():Boolean
		{
			return _repeat;
		}
		//
	}
}