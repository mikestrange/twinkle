package org.web.sdk.tool 
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.web.sdk.Ramt;
	import org.web.sdk.log.Log;
	
	public class SystemScope
	{
		private var _style:String = "center";
		// 实在范围
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _width:Number = 0;
		private var _height:Number = 0;
		//规定了舞台的最大宽度
		private var maxWidth:Number;
		private var maxHeight:Number;
		
		public function SystemScope(maxw:Number = 500, maxh:Number = 400) 
		{
			maxWidth = maxw;
			maxHeight = maxh;
			Ramt.stage.addEventListener(Event.RESIZE, update);
			update();
			Log.log(this).debug("启动：窗口显示最大区域是->", maxWidth, maxHeight);
		}
		
		public function update(data:Object = null):void
		{
			var dw:Number = Ramt.stage.stageWidth;
			var dh:Number = Ramt.stage.stageHeight;
			_width = maxWidth > dw ? dw : maxWidth;
			_height = maxHeight > dh ? dh : maxHeight;
			//重新定义位置
			setLocation((dw - _width) >> 1, (dh - _height) >> 1);
			Log.log(this).debug("#窗口信息->", this, "\t舞台信息->", x,y,_width, _height);
		}
		
		public function setStyle(style:String):void
		{
			_style = style;
		}
		
		//设置位置
		protected function setLocation(x:Number, y:Number):void
		{
			_x = x >> 0;
			_y = y >> 0;
		}
		
		//重新设置窗口大小
		public function setSize(w:Number, h:Number):void
		{
			Log.log(this).debug("警告：重新设置. 窗口显示最大区域是->", w, h);
			maxWidth = w >> 0;
			maxHeight = h >> 0;
			update();
		}
		
		//get
		public function get width():Number
		{
			return _width;
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function get x():Number
		{
			return _x;
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		public function dispose():void
		{
			_width = 0;
			_height = 0;
			_x = 0;
			_y = 0;
			Ramt.stage.removeEventListener(Event.RESIZE, update);
		}
		
		//信息
		public function toString():String
		{
			return "[x=" + _x + ", y=" + _y + ", width=" + _width + ", height=" + _height + "]";
		}
		//ends
	}
}