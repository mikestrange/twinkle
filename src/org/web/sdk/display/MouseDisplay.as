package org.web.sdk.display 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import org.web.sdk.display.asset.KitFactory;
	import org.web.sdk.Crystal;
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
			Crystal.addStageListener(MouseEvent.MOUSE_MOVE, onMove);
			Crystal.addStageListener(MouseEvent.MOUSE_DOWN, onState);
			Crystal.addStageListener(MouseEvent.MOUSE_UP, onState);
			//屏蔽鼠标右键
			Crystal.addStageListener("rightMouseDown", function(event:Object):void{});
		}
		
		public static function hide():void 
		{
			if (!isshow) return;
			isshow = !isshow;
			Mouse.show();
			if (upSprite) upSprite.removeFromFather();
			if (downSprite) downSprite.removeFromFather();
			Crystal.removeStageListener(MouseEvent.MOUSE_MOVE, onMove);
			Crystal.removeStageListener(MouseEvent.MOUSE_DOWN, onState);
			Crystal.removeStageListener(MouseEvent.MOUSE_UP, onState);
		}
		
		private static function onMove(event:MouseEvent = null):void
		{
			if (isDown) {
				if (downSprite) {
					downSprite.moveTo(Crystal.stage.mouseX, Crystal.stage.mouseY);
				}
			}else {
				if (upSprite) {
					upSprite.moveTo(Crystal.stage.mouseX, Crystal.stage.mouseY);
				}
			}
			event.updateAfterEvent();
		}
		
		private static function onState(event:MouseEvent):void
		{
			isDown = (event.type == MouseEvent.MOUSE_DOWN);
			if (event.type == MouseEvent.MOUSE_DOWN) {
				if (upSprite) upSprite.removeFromFather();
				if (downSprite && !downSprite.isAdded()) {
					Crystal.stage.addChild(downSprite as DisplayObject);
				}
			}else {
				if (downSprite) downSprite.removeFromFather();
				if (upSprite && !upSprite.isAdded()) {
					Crystal.stage.addChild(upSprite as DisplayObject);
				}
			}
			onMove(event);
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
			if (upSprite && !upSprite.isAdded()) {
				Crystal.stage.addChild(upSprite as DisplayObject);
			}
		}
		
		public static function isMouseDown():Boolean
		{
			return isDown;
		}
		
		//end
	}

}