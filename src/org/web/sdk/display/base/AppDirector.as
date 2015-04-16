package org.web.sdk.display.base 
{
	import flash.display.DisplayObjectContainer;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.interfaces.IBaseScene;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.interfaces.IDirector;
	import org.web.sdk.log.Log;
	
	public class AppDirector implements IDirector
	{
		private static var _ins:AppDirector = null;
		
		public static function gets():AppDirector
		{
			if (null == _ins) {
				_ins = new AppDirector;
			}
			return _ins;
		}
		
		private var _current:IBaseScene;
		private var _root:IBaseSprite;
		private var _apply:Function;
		
		public function setContainer(root:IBaseSprite):void
		{
			if (_root) throw Error("不允许多次设置");
			_root = root;
		}
		
		//回调一个场景的方法
		public function set sceneHandler(value:Function):void
		{
			_apply = value;
		}
		
		public function get root():IBaseSprite
		{
			return _root;
		}
		
		public function get current():IBaseScene
        {
            return _current;
        }
		
		public function isNote(target:IBaseScene):Boolean
        {
            if (_current == target) return true;
            return false;
        }
		
		/*
		 * 3个重要的方法
		 * */
		//
		public function enterScene(name:String):void
		{
			if (_apply is Function) {
				gotoCurrent(_apply(name) as IBaseScene);
			}
		}
		
		//直接退出和其他没关系
		public function closeScene(target:IBaseScene):void
		{
			if (target) {
				Log.log(this).debug("#close scene:", target);
				if (_current == target) {
					_current = null;
				}
				target.onExit();
			}
		}
		
		//回溯，不会设置当前的上级，不破坏但却层级
		public function skipPrev():Boolean
		{
			if (_current) return gotoCurrent(_current.prevScene);
			return false;
		}
		
		public function skipNext():Boolean
		{
			if (_current) return gotoCurrent(_current.nextScene);
			return false;
		}
		
		//隐藏函数
		protected function gotoCurrent(current:IBaseScene):Boolean
		{
			if (current == null || current == _current) return false;
			if (_current)
			{
				Log.log(this).debug("#exit scene:", _current);
				_current.onExit();
				current.prevScene = _current;
			}
			_current = current;
			Log.log(this).debug("#enter scene:", _current);
			_current.onEnter();
			_root.addDisplay(_current.getBaseSprite());
			return true;
		}
		
		//end
	}

}