package org.web.sdk.display.core.base 
{
	import flash.display.BitmapData;
	import org.web.sdk.display.asset.KitAction;
	
	//一个抽象的动作集合
	public class ActionMovie extends RayMovieClip 
	{
		private var _actionName:String;
		
		public function setAction(name:String):void
		{
			_actionName = name;
		}
		
		public function get action():String
		{
			return _actionName;
		}
		
		public function get defName():String
		{
			return null;
		}
		
		//自己去建立一套动作,因为我们需要隐藏渲染体，所以创造渲染体就在这里
		public function createAction(action:String):Vector.<BitmapData>
		{
			return null;
		}
		
		//ends
	}

}