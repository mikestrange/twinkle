package org.web.sdk.display 
{
	import org.web.sdk.display.core.BaseSprite;
	import org.web.sdk.display.interfaces.IBaseScene;
	
	public class Director extends BaseSprite
	{
		private var _currentScene:IBaseScene;
		
		public function gotoScene(scene:IBaseScene):void
		{
			if (scene == _currentScene) return;
			if (_currentScene == null) {
				_currentScene = scene;
				this.addDisplay(_currentScene);
				_currentScene.onEnter();
			}else {
				scene.prevScene = _currentScene;
				_currentScene = scene;
				_currentScene.onEnter();
			}
		}
		
		public function removeScene(scene:IBaseScene):void
		{
			if (scene) {
				scene.onExit();
				scene.removeFromFather(true);
				if (_currentScene == scene) _currentScene = null;
			}
		}
		
		public function get currentScene():IBaseScene
        {
            return _currentScene;
        }
		
		//回溯
		public function revertPrevScene():Boolean
		{
			return false;
		}
		
		public function isInScene(scene:IBaseScene):Boolean
        {
            if (_currentScene == scene) return true;
            return false;
        }
		//end
	}

}