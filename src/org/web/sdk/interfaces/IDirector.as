package org.web.sdk.interfaces 
{
	import org.web.sdk.interfaces.IBaseSprite;
		
	public interface IDirector 
	{
		function goto(scene:IBaseScene):void;
		function quit(scene:IBaseScene):void;
		function black():Boolean;
		function get current():IBaseScene;
		//是否
		function isNote(scene:IBaseScene):Boolean;
		//---
		function getRoot():IBaseSprite;
		//end
	}
	
}