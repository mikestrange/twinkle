package org.web.sdk.interfaces 
{
	import org.web.sdk.interfaces.IBaseSprite;
		
	public interface IDirector 
	{
		//进入场景
		function enterScene(name:String):void;	
		//关闭
		function closeScene(scene:IBaseScene):void;	
		//回退到上个场景
		function skipPrev():Boolean;	
		function skipNext():Boolean;
		//是否
		function isNote(scene:IBaseScene):Boolean;
		function set sceneHandler(value:Function):void;
		function get current():IBaseScene;
		function get root():IBaseSprite;
		function setContainer(root:IBaseSprite):void;
		//end
	}
	
}