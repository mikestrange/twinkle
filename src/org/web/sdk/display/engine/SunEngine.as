package org.web.sdk.display.engine 
{
	import flash.events.IEventDispatcher;
	import org.web.sdk.display.engine.IStepper;
	import flash.utils.getTimer;
	import org.web.sdk.beyond_challenge;
	import org.web.sdk.FrameWork;
	import org.web.sdk.log.Log;
	
	use namespace beyond_challenge
	/**
	 * @author 太阳，一切动力来源[引擎]
	 */
	final public class SunEngine 
	{
		public static const NONE:int = 0;
		public static const NAN:int = -1;
		public static const ENTER_FRAME:String = 'enterFrame';
		//
		beyond_challenge static var _root:IEventDispatcher = null;
		beyond_challenge static var _isplay:Boolean = false;
		beyond_challenge static var _isopen:Boolean = false;
		beyond_challenge static var _pauseTime:int;
		//
		beyond_challenge static var stepVector:Vector.<IStepper>;
		
		public function SunEngine() { throw Error('no do'); }
		
		/*
		 * 开放引擎 root
		 * */
		public static function open(root:IEventDispatcher = null):void
		{
			if (root == null) root = FrameWork.stage;
			if (!_isopen) {
				Log.log().debug('#启动引擎->立刻启动');
				_root = root;
				_isopen = true;
				_isplay = true;
				stepVector = new Vector.<IStepper>;
			}
		}
		
		/*
		 * 直接关闭引擎
		 * */
		public static function close():void
		{
			if (_isopen) {
				Log.log().debug('#关闭引擎->立刻清理');
				killfor();
				_isopen = false;
				_isplay = false;
				stepVector = null;
			}
		}
		
		/*
		 * 是否开放引擎
		 * */
		public static function isOpen():Boolean
		{
			return _isopen;
		}
		
		/*
		 * 是否启动了引擎
		 * */
		public static function isPlay():Boolean
		{
			return _isplay;
		}
		
		/*
		 * 停止引擎
		 * */
		public static function stop():Boolean
		{
			if (_isopen && _isplay)
			{
				Log.log().debug('#停止引擎');
				_isplay = !_isplay;
				_pauseTime = getTimer();
				var step:IStepper;
				for each(step in stepVector) {
					_root.removeEventListener(SunEngine.ENTER_FRAME, step.step);
				}
				return true;
			}
			return false;
		}
		
		/*
		 * 启动
		 * */
		public static function play():Boolean
		{
			if (_isopen && !_isplay) 
			{
				Log.log().debug('#运行引擎');
				_isplay = !_isplay;
				_pauseTime = NAN;	//记录暂停的时间
				var step:IStepper;
				for each(step in stepVector) {
					_root.addEventListener(SunEngine.ENTER_FRAME, step.step);
				}
				return true;
			}
			return false;
		}
		
		/*
		 * 启动一个离子	[只有启动了才注册]
		 * */
		public static function run(step:IStepper):Boolean
		{
			if (_isopen && !isRegister(step)) 
			{
				stepVector.push(step);
				if (_isplay) _root.addEventListener(SunEngine.ENTER_FRAME, step.step);
				return true;
			}
			return false;
		}
		
		/*
		 * 终止一个  [没被注册就会失败]
		 * */
		public static function cut(step:IStepper):Boolean
		{
			if (_isopen) 
			{
				var index:int = stepVector.indexOf(step);
				if (index != -1) 
				{
					stepVector.splice(index, 1);
					_root.removeEventListener(SunEngine.ENTER_FRAME, step.step);
					return true;
				}
				return false;
			}
			return false;
		}
		
		/*
		 * 这里是直接删除元件或者显示
		 * */
		public static function killfor():void
		{
			if (_isopen) {
				Log.log().debug('#杀死并且清空引擎');
				var step:IStepper;
				for (var i:int = stepVector.length - 1; i >= NONE; i--) {
					step = stepVector[i];
					_root.removeEventListener(SunEngine.ENTER_FRAME, step.step);
					stepVector.splice(i, 1);
				}
			}
		}
		
		/*
		 * 是否注册过
		 * */
		public static function isRegister(element:IStepper):Boolean {
			return stepVector.indexOf(element) >= NONE;
		}
		
		/*
		 * 如果暂停，可以取得这个暂停时间长
		 * */
		public static function get sleepTime():int
		{ 
			if (_pauseTime == NAN) return -1;
			return getTimer() - _pauseTime; 
		}
		//ends
	}

}