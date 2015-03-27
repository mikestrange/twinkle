package org.web.sdk.sound  
{
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import org.web.sdk.Ramt;
	import org.web.sdk.sound.core.ISound;
	import org.web.sdk.sound.core.Song;
	
	public class SoundManager 
	{
		public static const _BG_:int = 1;		//背景
		public static const _ACTION_:int = 2;	//动作
		public static const _BE_TIME_:int = 3;	//及时
		public static const _MINI_:int = 4;		//长久
		//
		private static var _ins:SoundManager;
		//
		private var hash:Dictionary;
		
		public function SoundManager() 
		{
			initialization();
		}
		
		public static function gets():SoundManager
		{
			if (null == _ins) _ins = new SoundManager;
			return _ins;
		}
		
		private function initialization():void
		{
			hash = new Dictionary;
			register(new SoundData(_BG_, true, true));			//重复,单一     [永久单一播放]
			register(new SoundData(_ACTION_, false, false));	//不重复,不单一 [多个音效可以同时播放，播放立刻结束]
			register(new SoundData(_BE_TIME_, false, true));	//不重复，单一  [只能播放一个，且播放完成立刻结束]
			register(new SoundData(_MINI_, true, false));		//重复，不单一	[永久混合声音]
		}
		
		private function register(data:SoundData):void
		{
			hash[data.type] = data;
		}
		
		public function getManager(type:int):SoundData
		{
			return hash[type];
		}
		
		//播放音效  类型和类名
		public static function play(name:String, type:int = _BG_):ISound
		{
			var data:SoundData = gets().getManager(type);
			if (data == null) throw Error('不存在的音频管理类型');
			var song:ISound = createSoundByName(name, data.repeat, data.type);
			if (song) data.add(song).play();
			return song;
		}
		
		//播放声音流
		public static function playUrl(url:String, type:int = _BG_):ISound
		{
			var data:SoundData = gets().getManager(type);
			if (data == null) throw Error('不存在的音频管理类型');
			var song:ISound = createSoundByHttp(url, data.repeat, data.type);
			if (song) {
				data.add(song).play();
			}else {
				trace("没有声音", url);
			}
			return song;
		}
		
		//关闭某个声音
		public static function closeByName(type:int, name:String = null):void
		{
			var data:SoundData = gets().getManager(type);
			if (data == null) throw Error('不存在的音频管理类型');
			if (name == null || name == '') {
				data.removeAndCloseAll();
			}else {
				data.removeByName(name);
			}
		}
		
		//设置某个音效的声音
		public static function setVolums(type:int, value:Number = 1, name:String = null, time:Number = 0.5):void
		{
			var data:SoundData = gets().getManager(type);
			if (data == null) throw Error('不存在的音频管理类型');
			if (name == null || name == '') {
				data.eachValue(setSongVolum, null, value, time);
			}else {
				var song:ISound = data.getByName(name);
				if (song) setSongVolum(song,value, time);
			}
		}
		
		private static function setSongVolum(song:ISound, value:Number, time:Number):void
		{
			TweenLite.killTweensOf(song);
			TweenLite.to(song, time, { volume:value } );
		}
		
		//设置所有音效的声音大小
		public static function setAllVolums(value:Number = 1, time:Number = 0.5):void
		{
			var data:SoundData;
			for each(data in gets().hash) data.eachValue(setSongVolum, null, value, time);
		}
		
		//关闭所有音效
		public static function closeAll():void
		{
			for(var type:* in gets().hash) closeByName(parseInt(type));
		}
		
		//取本地声音
		private static function createSoundByName(className:String, long:Boolean = false, type:int = 0):ISound
		{
			var song:Sound = Ramt.getAsset(className) as Sound;
			if (song == null) return null;
			return new Song(song, className, long, type);
		}
		
		//网络声音流
		private static function createSoundByHttp(url:String, long:Boolean = false, type:int = 0):ISound
		{
			var song:Song = new Song(new Sound, url, long, type, true);
			song.addEventListener(Song.ERROR, onError, false, 0, true);
			song.load();
			return song;
		}
		
		//网络错误流，删除声音
		private static function onError(e:Event):void
		{
			var song:Song = e.target as Song;
			song.removeEventListener(Song.ERROR, onError);
			closeByName(song.type, song.name);
		}
		//ends
	}

}
