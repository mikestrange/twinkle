package org.web.sdk.display 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import org.web.sdk.display.asset.KitFactory;
	import org.web.sdk.Ramt;
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
			Ramt.addStageListener(MouseEvent.MOUSE_MOVE, onMove);
			Ramt.addStageListener(MouseEvent.MOUSE_DOWN, onState);
			Ramt.addStageListener(MouseEvent.MOUSE_UP, onState);
			//屏蔽鼠标右键
			Ramt.addStageListener("rightMouseDown", function(event:Object):void{});
		}
		
		public static function hide():void 
		{
			if (!isshow) return;
			isshow = !isshow;
			Mouse.show();
			if (upSprite) upSprite.removeFromFather();
			if (downSprite) downSprite.removeFromFather();
			Ramt.removeStageListener(MouseEvent.MOUSE_MOVE, onMove);
			Ramt.removeStageListener(MouseEvent.MOUSE_DOWN, onState);
			Ramt.removeStageListener(MouseEvent.MOUSE_UP, onState);
		}
		
		private static function onMove(e:MouseEvent = null):void
		{
			if (isDown) {
				if (downSprite) {
					downSprite.moveTo(Ramt.stage.mouseX, Ramt.stage.mouseY);
				}
			}else {
				if (upSprite) {
					upSprite.moveTo(Ramt.stage.mouseX, Ramt.stage.mouseY);
				}
			}
		}
		
		private static function onState(e:MouseEvent):void
		{
			isDown = (e.type == MouseEvent.MOUSE_DOWN);
			if (e.type == MouseEvent.MOUSE_DOWN) {
				upSprite.removeFromFather();
				if (!downSprite.isAdded()) {
					Ramt.stage.addChild(downSprite.convertDisplay());
				}
			}else {
				downSprite.removeFromFather();
				if (!upSprite.isAdded()) {
					Ramt.stage.addChild(upSprite.convertDisplay());
				}
			}
			onMove();
		}
		
		public static function setDown(display:IDisplay):void
		{
			if (downSprite) downSprite.removeFromFather(true);
			downSprite = display;
			if (isDown && !downSprite.isAdded()) {
				Ramt.stage.addChild(downSprite.convertDisplay());
			}
			onMove();
		}
		
		public static function setRelease(display:IDisplay):void
		{
			if (upSprite) upSprite.removeFromFather(true);
			upSprite = display;
			if (!isDown && !upSprite.isAdded()) {
				Ramt.stage.addChild(upSprite.convertDisplay());
			}
			onMove();
		}
		
		public static function isMouseDown():Boolean
		{
			return isDown;
		}
		
		//end
	}

}