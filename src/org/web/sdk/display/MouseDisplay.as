package org.web.sdk.display 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import org.web.sdk.display.asset.KitFactory;
	import org.web.sdk.display.core.RayDisplayer;
	import org.web.sdk.Mentor;
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
			Mentor.addStageListener(MouseEvent.MOUSE_MOVE, onMove);
			Mentor.addStageListener(MouseEvent.MOUSE_DOWN, onState);
			Mentor.addStageListener(MouseEvent.MOUSE_UP, onState);
			//屏蔽鼠标右键
			Mentor.addStageListener("rightMouseDown", function(event:Object):void{});
		}
		
		public static function hide():void 
		{
			if (!isshow) return;
			isshow = !isshow;
			Mouse.show();
			if (upSprite) upSprite.removeFromFather();
			if (downSprite) downSprite.removeFromFather();
			Mentor.removeStageListener(MouseEvent.MOUSE_MOVE, onMove);
			Mentor.removeStageListener(MouseEvent.MOUSE_DOWN, onState);
			Mentor.removeStageListener(MouseEvent.MOUSE_UP, onState);
		}
		
		private static function onMove(e:MouseEvent = null):void
		{
			if (isDown) {
				if (downSprite) {
					downSprite.moveTo(Mentor.stage.mouseX, Mentor.stage.mouseY);
				}
			}else {
				if (upSprite) {
					upSprite.moveTo(Mentor.stage.mouseX, Mentor.stage.mouseY);
				}
			}
		}
		
		private static function onState(e:MouseEvent):void
		{
			isDown = (e.type == MouseEvent.MOUSE_DOWN);
			if (e.type == MouseEvent.MOUSE_DOWN) {
				if (upSprite) upSprite.removeFromFather();
				if (downSprite && !downSprite.isAdded()) {
					Mentor.stage.addChild(downSprite as DisplayObject);
				}
			}else {
				if (downSprite) downSprite.removeFromFather();
				if (upSprite && !upSprite.isAdded()) {
					Mentor.stage.addChild(upSprite as DisplayObject);
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
			if (upSprite && !upSprite.isAdded()) {
				Mentor.stage.addChild(upSprite as DisplayObject);
			}
		}
		
		public static function isMouseDown():Boolean
		{
			return isDown;
		}
		
		//end
	}

}