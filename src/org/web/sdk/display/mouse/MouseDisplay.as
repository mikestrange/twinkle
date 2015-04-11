package org.web.sdk.display.mouse 
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import org.web.sdk.display.asset.AssetFactory;
	import org.web.sdk.AppWork;
	import org.web.sdk.interfaces.IDisplay;
	/*
	 * 切换鼠标状态，一个简单的，根据需求再调整
	 * */
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
			AppWork.addStageListener(MouseEvent.MOUSE_MOVE, onMove);
			AppWork.addStageListener(MouseEvent.MOUSE_DOWN, onState);
			AppWork.addStageListener(MouseEvent.MOUSE_UP, onState);
			//屏蔽鼠标右键
			AppWork.addStageListener("rightMouseDown", function(event:Object):void{});
		}
		
		public static function hide():void 
		{
			if (!isshow) return;
			isshow = !isshow;
			Mouse.show();
			if (upSprite) upSprite.removeFromFather();
			if (downSprite) downSprite.removeFromFather();
			AppWork.removeStageListener(MouseEvent.MOUSE_MOVE, onMove);
			AppWork.removeStageListener(MouseEvent.MOUSE_DOWN, onState);
			AppWork.removeStageListener(MouseEvent.MOUSE_UP, onState);
		}
		
		private static function onMove(event:MouseEvent = null):void
		{
			if (isDown) {
				if (downSprite) {
					downSprite.moveTo(AppWork.stage.mouseX, AppWork.stage.mouseY);
				}
			}else {
				if (upSprite) {
					upSprite.moveTo(AppWork.stage.mouseX, AppWork.stage.mouseY);
				}
			}
			//if(event) event.updateAfterEvent();
		}
		
		private static function onState(event:MouseEvent):void
		{
			isDown = (event.type == MouseEvent.MOUSE_DOWN);
			if (event.type == MouseEvent.MOUSE_DOWN) {
				if (upSprite) upSprite.removeFromFather();
				if (downSprite && !downSprite.isAdded()) {
					AppWork.stage.addChild(downSprite as DisplayObject);
				}
			}else {
				if (downSprite) downSprite.removeFromFather();
				if (upSprite && !upSprite.isAdded()) {
					AppWork.stage.addChild(upSprite as DisplayObject);
				}
			}
			onMove(event);
		}
		
		public static function setDown(display:IDisplay):void
		{
			if (downSprite) downSprite.removeFromFather(true);
			downSprite = display;
			if (isDown && !downSprite.isAdded()) {
				AppWork.stage.addChild(downSprite.convertDisplay());
			}
			onMove();
		}
		
		public static function setRelease(display:IDisplay):void
		{
			if (upSprite) upSprite.removeFromFather(true);
			upSprite = display;
			if (upSprite && !upSprite.isAdded()) {
				AppWork.stage.addChild(upSprite as DisplayObject);
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