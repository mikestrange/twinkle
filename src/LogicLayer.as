package 
{
	import game.consts.NoticeDefined;
	import game.datas.SelfData;
	import game.GameGlobal;
	import org.web.sdk.display.RawSprite;
	import org.web.sdk.FrameWork;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.web.sdk.net.socket.AssignedTransfer;
	import org.web.sdk.net.socket.ServerSocket;
	import org.web.sdk.tool.Clock;
	
	
	public class LogicLayer extends RawSprite
	{
		private static var _ins:LogicLayer;
		
		public static function gets():LogicLayer
		{
			if (_ins == null) {
				_ins = new LogicLayer;
				_ins.initialization();
			}
			return _ins;
		}
		
		private var idTextInput:TextField;
		private var pwTextInput:TextField;
		
		override public function initialization(value:Boolean = true):void 
		{
			super.initialization(value);
			idTextInput = new TextField();
			idTextInput.type = TextFieldType.INPUT;
			idTextInput.background = true;
			idTextInput.backgroundColor = 0xEEEEEE;
			idTextInput.autoSize = TextFieldAutoSize.NONE;
			idTextInput.multiline = false;
			idTextInput.width = 120;
			idTextInput.height = 24;
			idTextInput.textColor = 0;
			idTextInput.text = "1001";
			idTextInput.autoSize = TextFieldAutoSize.CENTER; 
			var format:TextFormat = new TextFormat("宋体",24,0,null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,-5);
			format.align = TextFormatAlign.CENTER;
			idTextInput.defaultTextFormat = format;
			idTextInput.x = (FrameWork.stageWidth - idTextInput.width)/2;
			idTextInput.y = (FrameWork.stageHeight - idTextInput.width)/2;
			addChild(idTextInput);
			
			pwTextInput = new TextField();
			pwTextInput.type = TextFieldType.INPUT;
			pwTextInput.background = true;
			pwTextInput.backgroundColor = 0xEEEEEE;
			pwTextInput.multiline = false;
			pwTextInput.width = 120;
//			pwTextInput.height = 30;
			pwTextInput.textColor = 0;
			pwTextInput.text = "abc";
			pwTextInput.wordWrap = true;
			pwTextInput.autoSize = TextFieldAutoSize.CENTER; 
			var format1:TextFormat = new TextFormat("宋体",24,0,null,null,null,null,null,TextFormatAlign.CENTER,null,null,null,-2);
			pwTextInput.defaultTextFormat = format1;
			pwTextInput.x = (FrameWork.stageWidth - idTextInput.width)/2;
			pwTextInput.y = (FrameWork.stageHeight - idTextInput.width)/2 + 40;
			addChild(pwTextInput);
			
			var spt:Sprite = new Sprite;
			var loginText:TextField = new TextField();
			loginText.type = TextFieldType.DYNAMIC;
			loginText.mouseEnabled = true;
			loginText.selectable = false;
			loginText.autoSize = TextFieldAutoSize.CENTER;
			loginText.border = true;
			loginText.borderColor = 0x00ff00;
			loginText.background = true;
			loginText.backgroundColor = 0x11ff11;
			loginText.width = 120;
			loginText.height = 30;
			loginText.x = (FrameWork.stageWidth - idTextInput.width)/2 + 40;
			loginText.y = (FrameWork.stageHeight - idTextInput.width)/2 + 80;
			loginText.text = " login ";
			var format2:TextFormat = new TextFormat("宋体",20);
			loginText.defaultTextFormat = format2;
			addChild(spt);
			spt.mouseChildren = false;
			spt.buttonMode = true;
			spt.addChild(loginText);
			spt.addEventListener(MouseEvent.CLICK, loginEvent, false, 0, true);
			//
		}
		
		public function show():void 
		{
			FrameWork.stage.addChild(this);
			if (GameGlobal.isDebug) minaLine(null);
		}
		
		private function loginEvent(e:Event):void
		{
			ServerSocket.socket.link('127.0.0.1', 9555, minaLine);
		}
		
		private function minaLine(e:Object):void
		{
			this.removeFromFather();
			SelfData.gets().uid = parseInt(idTextInput.text);
			ServerSocket.socket.sendNotice(NoticeDefined.SET_LOGIC, [parseInt(idTextInput.text), pwTextInput.text]);
		}
		//ends
	}
}