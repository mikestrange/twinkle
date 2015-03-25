package org.web.sdk.display 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import org.web.sdk.display.asset.KitFactory;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.FrameWork;
	import org.web.sdk.inters.IDisplay;
	
	public class MouseDisplay 
	{
		private static var downSprite:IDisplay;
		private static var upSprite:IDisplay;
		private static var isDown:Boolean;
		private static var isshow:Boolean = false;
		
		public static function show():void 
		{
			if (isshow) return;
			isshow = !isshow;
			Mouse.hide();
			FrameWork.addStageListener(MouseEvent.MOUSE_MOVE, onMove);
			FrameWork.addStageListener(MouseEvent.MOUSE_DOWN, onState);
			FrameWork.addStageListener(MouseEvent.MOUSE_UP, onState);
			//屏蔽鼠标右键
			FrameWork.addStageListener("rightMouseDown", function(event:Object):void{});
		}
		
		public static function hide():void 
		{
			if (!isshow) return;
			isshow = !isshow;
			Mouse.show();
			if (upSprite) upSprite.removeFromFather();
			if (downSprite) downSprite.removeFromFather();
			FrameWork.removeStageListener(MouseEvent.MOUSE_MOVE, onMove);
			FrameWork.removeStageListener(MouseEvent.MOUSE_DOWN, onState);
			FrameWork.removeStageListener(MouseEvent.MOUSE_UP, onState);
		}
		
		private static function onMove(e:MouseEvent = null):void
		{
			if (isDown) {
				if (downSprite) {
					downSprite.moveTo(FrameWork.stage.mouseX, FrameWork.stage.mouseY);
				}
			}else {
				if (upSprite) {
					upSprite.moveTo(FrameWork.stage.mouseX, FrameWork.stage.mouseY);
				}
			}
		}
		
		private static function onState(e:MouseEvent):void
		{
			isDown = (e.type == MouseEvent.MOUSE_DOWN);
			if (e.type == MouseEvent.MOUSE_DOWN) {
				if (upSprite) upSprite.removeFromFather();
				if (downSprite && !downSprite.isAdded()) {
					FrameWork.stage.addChild(downSprite as DisplayObject);
				}
			}else {
				if (downSprite) downSprite.removeFromFather();
				if (upSprite && !upSprite.isAdded()) {
					FrameWork.stage.addChild(upSprite as DisplayObject);
				}
			}
			onMove();
		}
		
		public static function setDown(display:IDisplay):void
		{
			if (downSprite) downSprite.removeFromFather(true);
			downSprite = display;
		}
		
		public static function setRelease(display:IDisplay):void
		{
			if (upSprite) upSprite.removeFromFather(true);
			upSprite = display;
		}
		
		public static function isMouseDown():Boolean
		{
			return isDown;
		}
		
		//end
	}

}