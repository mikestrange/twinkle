package org.web.sdk.sound.core 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.net.URLRequest;
	import org.web.sdk.log.Log;
	import org.web.sdk.sound.SoundManager;
	
	public class Song extends EventDispatcher implements ISound 
	{
		public static const ERROR:String = 'error';
		public static const COMPLETE:String = 'complete';
		//
		private var _sound:Sound;
		private var _name:String;
		private var _long:Boolean;
		private var _isplay:Boolean;
		private var _soundchannel:SoundChannel;
		private var _soundTransform:SoundTransform;
		private var _type:int;
		private var _remote:Boolean = false;	//是否远程加载
		private var _isload:Boolean = true;	//是否下载完成
		
		public function Song($sound:Sound, $name:String = null, $long:Boolean = false, $type:int = 0, $remote:Boolean = false) 
		{
			_sound = $sound;
			_name = $name;
			_long = $long;
			_type = $type;
			_remote = $remote;
			_soundTransform = new SoundTransform;
		}
		
		//网络资源才允许下载
		public function load():void
		{
			if (!_remote) return;
			_sound.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			_sound.addEventListener(Event.COMPLETE, complete, false, 0, true);
			_isload = false;
			_sound.load(new URLRequest(_name));
		}
		
		protected function complete(e:Event):void
		{
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_sound.removeEventListener(Event.COMPLETE, complete);
			_isload = true;
			Log.log(this).debug('#下载音频完成:', _name);
			this.dispatchEvent(new Event(COMPLETE));
		}
		
		protected function onError(e:IOErrorEvent):void
		{
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			_sound.removeEventListener(Event.COMPLETE, complete);
			_isload = true;
			Log.log(this).debug('#下载音频出错:', _name);
			this.dispatchEvent(new Event(ERROR));
		}
		
		/* INTERFACE interfaces.ISound */
		public function play(startTime:int = 0):void 
		{
			if (_isplay) stop();
			_isplay = true;
			_soundchannel = _sound.play(startTime, 0, _soundTransform);
			_soundchannel.addEventListener(Event.SOUND_COMPLETE, soundComplete, false, 0, true);
		}
		
		private function soundComplete(event:Event):void
		{
			if (_long) play(0);
			if (_type == SoundManager._ACTION_) SoundManager.closeByName(_type, _name);
			this.dispatchEvent(event);
		}
		
		public function stop():void 
		{
			if (_isplay) {
				_isplay = false;
				_soundchannel.stop();
				_soundchannel = null;
			}
		}
		
		public function isPlay():Boolean 
		{
			return _isplay;
		}
		
		//不是关闭流，而是关闭音效
		public function close():void 
		{
			stop();
			if (_remote && !_isload) {
				_isload = true;
				try {
					_sound.close();
				}catch (e:Error) {
					
				}
			}
		}
		
		public function free():void
		{
			close();
		}
		
		public function get pointer():int 
		{
			if (_soundchannel) return _soundchannel.position;
			return 0;
		}
		
		public function get sound():Sound 
		{
			return _sound;
		}
		
		public function get soundchannel():SoundChannel 
		{
			return _soundchannel;
		}
		
		public function get soundTransform():SoundTransform 
		{
			return _soundTransform;
		}
		
		public function set soundTransform(value:SoundTransform):void 
		{
			_soundTransform = value;
			if(_isplay) _soundchannel.soundTransform = value;
		}
		
		public function set volume(value:Number):void 
		{
			if (volume == value) return;
			_soundTransform.volume = value;
			if(_isplay) _soundchannel.soundTransform = _soundTransform;
		}
		
		public function get volume():Number 
		{
			return _soundTransform.volume;
		}
		
		public function get long():Boolean 
		{
			return _long;
		}
		
		public function set long(value:Boolean):void 
		{
			_long = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function get remote():Boolean
		{
			return _remote;
		}
		//ends
	}

}