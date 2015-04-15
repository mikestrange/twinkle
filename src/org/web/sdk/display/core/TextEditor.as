package org.web.sdk.display.core 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.*;
	import org.web.sdk.display.utils.AlignType;
	import org.web.sdk.display.utils.Swapper;
	import org.web.sdk.AppWork;
	import org.web.sdk.interfaces.IBaseSprite;
	import org.web.sdk.interfaces.IDisplay;

	public class TextEditor extends TextField implements IDisplay 
	{
		private static const DEF_FORMAT:TextFormat = new TextFormat;
		//换行
		public static const NEXT:String = '\n';
		//文本设置
		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		public static const CENTER:String = 'center';
		public static const NONE : String = "none";
		
		// 基础
		private var _width:int;
		private var _height:int;
		private var _tag:uint;
		//操作
		private var _isresize:Boolean;
		private var _isrun:Boolean;
		//文本特有
		private var format:TextFormat;
		
		//默认左边自动转换
		public function TextEditor(auto:String = "left", mouse:Boolean = false, wrap:Boolean = false, wid:Number = 100, mult:Boolean = false) 
		{
			width = wid;
			wordWrap = wrap;			//是否自动转行
			multiline = mult;			//是否多行
			mouseEnabled = mouse;		//鼠标支持
			autoSize = auto;			//自动
			initialization();
		}
		
		protected function initialization():void
		{
			
		}
		
		//设置文本默认  取重要部分
		public function setPerpetual(font:String = null, color:uint = 0, size:int = 12, bold:Boolean = false, italic:Boolean = false, ud:Boolean = false, lead:int = 0, letter:int = 0):void
		{
			DEF_FORMAT.font = font;
			DEF_FORMAT.color = color;
			DEF_FORMAT.size = size;
			DEF_FORMAT.bold = bold;				//粗体
			DEF_FORMAT.italic = italic;			//斜体
			DEF_FORMAT.underline = ud;			//下划线
			DEF_FORMAT.leading = lead;			//行距
			DEF_FORMAT.letterSpacing = letter;	//字距
			defaultTextFormat = DEF_FORMAT;
		}
		
		//一旦设置背景颜色，背景被开启
		public function backColor(value:uint = 0):void
		{
			this.background = true;
			this.backgroundColor = value;
		}
		
		//一旦设置，周围线条被开启
		public function lineColor(value:uint = 0):void
		{
			this.border = true;
			this.borderColor = value;
		}
		
		//简易添加设置 下一个是否换行
		public function addText(newText:String, nextwarp:Boolean = false, color:Object = null, size:int = -1, font:String = null):void
		{
			if (null == newText || newText == "") return;
			if (null == format) format = new TextFormat;
			format.font = font == null ? defaultTextFormat.font : font;
			format.size = size < 0 ? defaultTextFormat.size : size;
			format.color = color == null ? defaultTextFormat.color : uint(color);
			format.bold = defaultTextFormat.bold;
			format.italic = defaultTextFormat.italic;
			format.underline = defaultTextFormat.underline;
			format.leading = defaultTextFormat.leading;
			format.letterSpacing =  defaultTextFormat.letterSpacing;
			addTextFormat(newText, nextwarp, format);
		}
		
		//自身内部定义
		protected function addTextFormat(newText:String, next:Boolean = false, format:TextFormat = null):void
		{
			const len:int = length;
			if (next) {
				appendText(newText + NEXT);
			}else {
				appendText(newText);
			}
			if (format) setTextFormat(format, len, length);
		}
		
		//修正范围
		public function tinkerRect(offx:Number = 0, offy:Number = 0):void
		{
			this.width = this.textWidth + offx;
			this.height = this.textHeight + offy;
		}
		
		//清空
		public function setEmpty():void
		{
			this.text = '';
		}
		
		/* INTERFACE org.web.sdk.interfaces.IDisplayObject */
		public function toGlobal(mx:Number = 0, my:Number = 0):Point
		{
			return this.localToGlobal(new Point(mx, my));
		}
		
		public function toLocal(mx:Number = 0, my:Number = 0):Point
		{
			return this.globalToLocal(new Point(mx, my));
		}
		
		public function setDisplayIndex(floor:int = -1):void 
		{
			if (parent) {
				if (parent.numChildren < 1) return;
				if (floor < 0) {
					parent.setChildIndex(this, parent.numChildren - 1);
				}else {
					if (floor > parent.numChildren - 1) floor = parent.numChildren - 1;
					parent.setChildIndex(this, floor);
				}
			}
		}
		
		public function clearFilters():void 
		{
			if (filters.length) {
				filters = [];
				filters = null;
			}
		}
		
		public function addUnder(father:IBaseSprite, floor:int = -1):Boolean 
		{
			if (father) {
				father.addDisplay(this, floor);
				return true;
			}
			return false;
		}
		
		public function frameRender(float:int = 0):void
		{
			
		}
		
		public function getFather():IBaseSprite
		{
			return this.parent as IBaseSprite;
		}
		
		public function isAdded():Boolean
		{
			return this.parent != null;
		}
		
		public function removeFromFather(value:Boolean = false):void
		{
			if (parent) parent.removeChild(this);
			if (value) this.finality();
		}
		
		public function setTag(value:uint):void 
		{
			_tag = value;
		}
		
		public function getTag():uint 
		{
			return _tag;
		}
		
		public function setSize(wide:int, high:int):void
		{
			_width = wide;
			_height = high;
		}
		
		public function get sizeWidth():int
		{
			if (_width == 0) return width;
			return _width;
		}
		
		public function get sizeHeight():int
		{
			if (_height == 0) return height;
			return _height;
		}
		
		public function moveTo(mx:Number = 0, my:Number = 0):void
		{
			if (mx != x) this.x = mx;
			if (my != y) this.y = my;
		}
		
		public function setScale(sx:Number = 1, sy:Number = 1):void
		{
			if (sx != scaleX) this.scaleX = sx;
			if (sy != scaleY) this.scaleY = sy;
		}
		
		public function setResize(value:Boolean = true):void
		{
			if (_isresize == value) return;
			_isresize = value;
			if (value) {
				AppWork.addStageListener(Event.RESIZE, onResize);
			}else {
				AppWork.removeStageListener(Event.RESIZE, onResize);
			}
		}
		
		public function setRunning(value:Boolean = false):void
		{
			if (_isrun == value) return;
			_isrun = value;
			if (value) {
				AppWork.addStageListener(Event.ENTER_FRAME, runEnter);
			}else {
				AppWork.removeStageListener(Event.ENTER_FRAME, runEnter);
			}
		}
		
		public function convertDisplay():DisplayObject
		{
			return this as DisplayObject;
		}
		
		public function finality(value:Boolean = true):void
		{
			clearFilters();
			setEmpty();
		}
		
		protected function runEnter(e:Event = null):void
		{
			
		}
		
		protected function onResize(e:Event = null):void
		{
			
		}
		
		//快速建立
		public static function quick(chat:String, parent:IBaseSprite = null, size:int = 12, color:Object = null, font:String = null):TextEditor
		{
			var text:TextEditor = new TextEditor();
			text.addText(chat, false, color, size, font);
			text.addUnder(parent);
			return text;
		}
		//ends
	}

}