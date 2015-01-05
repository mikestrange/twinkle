package org.web.sdk.sound.core 
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public interface ISound 
	{
		function play(index:int = 0):void;
		function stop():void;
		function isPlay():Boolean;
		function close():void;
		function get pointer():int;
		function get sound():Sound;
		function get soundchannel():SoundChannel;
		function get soundTransform():SoundTransform;
		function set volume(value:Number):void;
		function get volume():Number;
		function get long():Boolean;
		function set long(value:Boolean):void;
		function get name():String;
		function get type():int;
		function free():void;
		function get remote():Boolean; 
		//
	}
}