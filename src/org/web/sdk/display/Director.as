package org.web.sdk.display 
{
	import flash.display.DisplayObjectContainer;
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.interfaces.IBaseScene;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.interfaces.IDirector;
	
	public class Director implements IDirector
	{
		private var _current:IBaseScene;
		private var _root:IBaseSprite;
		
		public function Director(root:IBaseSprite)
		{
			_root = root;
		}
		
		public function getRoot():IBaseSprite
		{
			return _root;
		}
		
		public function goto(scene:IBaseScene):void
		{
			if (scene == null) return;
			if (scene == _current) return;
			if (_current) {
				_current.onExit();
				scene.prevScene = _current;
			}
			_current = scene;
			getRoot().addDisplay(_current);
			_current.onEnter();
		}
		
		//直接退出，会打断之前的排序，破坏当前层级
		public function quit(scene:IBaseScene):void
		{
			if (scene) {
				scene.onExit();
				if (_current == scene) _current = null;
				//如果存在上一级，那么返回
				if (scene.prevScene) goto(scene.prevScene);
			}else {
				trace("不存在的Scene");
			}
		}
		
		public function get current():IBaseScene
        {
            return _current;
        }
		
		//回溯，不会设置当前的上级，不破坏但却层级
		public function black():Boolean
		{
			if (_current && _current.prevScene) 
			{
				if (_current == _current.prevScene) return false;
				_current.onExit();
				_current = _current.prevScene;
				getRoot().addDisplay(_current);
				_current.onEnter();
				return true;
			}
			return false;
		}
		
		public function isNote(scene:IBaseScene):Boolean
        {
            if (_current == scene) return true;
            return false;
        }
		
		//end
	}

}