package org.web.sdk.display 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.*;
	import org.web.sdk.inters.IBaseSprite;
	import org.web.sdk.inters.IDisplayObject;

	public class TextEditor extends TextField implements IDisplayObject 
	{
		private static const DEF_FORMAT:TextFormat = new TextFormat;
		//换行
		public static const NEXT:String = '\n';
		//文本设置
		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		public static const CENTER:String = 'center';
		public static const NONE : String = "none";
		
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
		
		protected function initialization():void
		{
			
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
		public function addText(newText:String, nextwarp:Boolean = false, color:uint = 0, size:int = -1, font:String = null):void
		{
			if (null == newText||newText=="") return;
			var format:TextFormat = new TextFormat;
			format.font = font == null ? defaultTextFormat.font : font;
			format.size = size < 0 ? defaultTextFormat.size : size;
			format.color = color;
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
			if (wordWrap && next) {
				appendText(newText + NEXT);
			}else {
				appendText(newText);
			}
			if (format) setTextFormat(format, len, length);
		}
		
		//重新定位
		public function setSize(offx:Number = 0, offy:Number = 0):void
		{
			this.width = this.textWidth + offx;
			this.height = this.textHeight + offy;
		}
		
		//清空
		public function empty():void
		{
			this.text = '';
		}
		
		public function showEvent(event:Event = null):void 
		{
			
		}
		
		public function hideEvent(event:Event = null):void 
		{
			
		}
		
		public function clearFilters():void 
		{
			if (filters.length) {
				filters = [];
				filters = null;
			}
		}
		
		public function getMouse():Point 
		{
			return new Point(mouseX, mouseY);
		}
		
		public function getParent():IBaseSprite 
		{
			return parent as IBaseSprite;
		}
		
		public function removeFromFather():void
		{
			if (parent) parent.removeChild(this);
		}
		
		public function moveTo(mx:int = 0, my:int = 0):void 
		{
			this.x = mx;
			this.y = my;
		}
		
		public function follow(dis:IDisplayObject, ofx:Number = 0, ofy:Number = 0, global:Boolean = false):void 
		{
			if (global) {
				var p:Point = dis.localToGlobal(new Point);
				moveTo(p.x + ofx, p.y + ofy);
			}else {
				moveTo(dis.x + ofx, dis.y + ofy);
			}
		}
		
		public function setNorms(horizontal:Number = 1, vertical:Number = 1, ratio:Boolean = true):void 
		{
			if (ratio) {
				this.scaleX = horizontal;
				this.scaleY = vertical;
			}else {
				this.width = horizontal;
				this.height = vertical;
			}
		}
		
		public function addInto(father:IBaseSprite, mx:Number = 0, my:Number = 0, floor:int = -1):void
		{
			if (father) father.addDisplay(this, mx, my, floor);
		}
		
		public function render():void 
		{
			
		}
		
		public function setAuto(type:String = null):void 
		{
			
		}
		
		public function isshow():Boolean 
		{
			return parent != null;
		}
		//ends
	}

}