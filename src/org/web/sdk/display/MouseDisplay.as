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
		private static var down:IDisplay;
		private static var up:IDisplay;
		private static var isDown:Boolean;
		private static var isshow:Boolean = false;
		
		public static function show():void 
		{
			if (isshow) return;
			isshow = !isshow;
			up = new RayDisplayer(KitFactory.by_class("MouseNormal"));
			FrameWork.stage.addChild(up as DisplayObject);
			down = new RayDisplayer(KitFactory.by_class("MouseClick"));
			down.visible = false;
			FrameWork.stage.addChild(down as DisplayObject);
			//up.visible = false;
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
			FrameWork.removeStageListener(MouseEvent.MOUSE_MOVE, onMove);
			FrameWork.removeStageListener(MouseEvent.MOUSE_DOWN, onState);
			FrameWork.removeStageListener(MouseEvent.MOUSE_UP, onState);
		}
		
		private static function onMove(e:MouseEvent = null):void
		{
			if (isDown) {
				down.moveTo(FrameWork.stage.mouseX, FrameWork.stage.mouseY);
			}else {
				up.moveTo(FrameWork.stage.mouseX, FrameWork.stage.mouseY);
			}
		}
		
		private static function onState(e:MouseEvent):void
		{
			isDown = e.type == MouseEvent.MOUSE_DOWN;
			if (e.type == MouseEvent.MOUSE_DOWN) {
				up.visible = false;
				down.visible = true;
			}else {
				up.visible = true;
				down.visible = false;
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