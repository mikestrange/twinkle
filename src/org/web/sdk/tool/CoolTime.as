package org.web.sdk.tool 
{
	import flash.display.Shape;
	import flash.utils.getTimer;
	import flash.geom.Point;
	/*
	 * 一个非常好的矩形CD进度时间显示器
	 * */
	public class CoolTime extends Shape 
	{
		//
		private var _st:Number;
		private var _pt:Number;
		private var _cd:Number = 1000;		//cd时间
		//基本数据
		private var W:Number = 50;
		private var H:Number = 50;
		private var LENG:Number = 0;
		private var _vector:Vector.<Number>;
		//结束回调
		private var _callback:Function;
		private var _parameter:Array;
		private var _begin:Boolean;
		//颜色
		public var lineColor:uint = 0xff0000;
		public var brackColor:uint = 0x666666;
		private const THOUSAND:int = 1000;
		//
		private var _mildex:Number = 0;
		private var _mildey:Number = 0;
		
		public function CoolTime(sizew:int = 100, sizeh:int = 100)
		{
			setSize(sizew, sizeh);
		}
		
		public function setSize(wide:int, heig:int):void
		{
			W = wide;
			H = heig;
			LENG = 2 * (W + H);
			_vector = Vector.<Number>([W / 2, W / 2 + H, W / 2 + H + W, W / 2 + H + W + H, W + H + W + H]);
		}
		
		//cd开始  结束之后会自动移除 传入秒
		public function setup(cdtime:Number, passtime:Number = 0, run:Boolean = true, called:Function = null, ...args):void
		{
			this._cd = cdtime * THOUSAND;						//这里用秒计时
			this._pt = passtime * THOUSAND;						//流失的时间	
			this._callback = called; 							//回调
			this._parameter = args;								//回调参数
			this._st = getTimer();
			frameConsume();
			if (run) start();
		}
		
		public function start():void
		{
			if (!_begin) {
				_st = getTimer();
				_begin = true;
				this.addEventListener("enterFrame", frameConsume);
			}
		}
		
		private function frameConsume(e:Object = null):void
		{
			var time:int = (getTimer() - _st) + _pt;
			gradually(time / _cd);
		}
		
		/*我们将他分为5段，这样才能正确绘制出来*/
		private function renderMask(middlex:int, middley:int, step:int = 0):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, lineColor);
			this.graphics.beginFill(brackColor);
			this.graphics.moveTo(W >> 1, 0);
			this.graphics.lineTo(W >> 1, H >> 1);
			this.graphics.lineTo(middlex, middley);
			//绘制分段
			if (step < 1) this.graphics.lineTo(W , 0);
			if (step < 2) this.graphics.lineTo(W , H);
			if (step < 3) this.graphics.lineTo(0 , H);
			if (step < 4) this.graphics.lineTo(0 , 0);
			if (step < 5) this.graphics.lineTo(W >> 1 , 0);
		}
		
		//通过长度 直接绘制
		private function gradually(scale:Number, called:Boolean = true):void
		{
			var leng:int = scale * LENG;
			if (leng >= LENG) {
				leng = LENG;
				kill(called);
			}
			var index:int = 0;
			for (index = 0; index < _vector.length; index++) {
				if (_vector[index] >= leng) break;
			}
			/* //下面替换
			var middle:Point = middleLocation(leng, index);
			renderMask(middle.x, middle.y, index);
			*/
			middleLocation(leng, index);
			renderMask(_mildex, _mildey, index);
		}
		
		public function stop():void
		{
			if (_begin) {
				_begin = false;
				this.removeEventListener("enterFrame", frameConsume);
			}
		}
		
		public function get passTime():Number
		{
			return _pt;
		}
		
		public function get cdTime():Number
		{
			return _cd;
		}
		
		private function middleLocation(leng:Number, step:int = 0):Point
		{
			switch(step)
			{
				case 0: //return new Point((W >> 1) + leng, 0);
					_mildex = (W >> 1) + leng;
					_mildey = 0;
				break;
				case 1: //return new Point(W, leng - _vector[step - 1]);
					_mildex = W;
					_mildey = leng - _vector[step - 1];
				break;
				case 2: //return new Point(W - (leng - _vector[step - 1]), H);
					_mildex = W - (leng - _vector[step - 1]);
					_mildey = H;
				break;
				case 3: //return new Point(0, H - (leng - _vector[step - 1]));
					_mildex = 0;
					_mildey = H - (leng - _vector[step - 1]);
				break;
				case 4: //return new Point(leng - _vector[step - 1], 0);
					_mildex = leng - _vector[step - 1];
					_mildey =  0;
				break;
				default:
					_mildex = W >> 1;
					_mildey = H >> 1;
				break;
			}
			return null;// new Point(W >> 1, H >> 1);
		}
		
		//消除CD
		public function kill(value:Boolean = false):void
		{
			kill_self();
			stop();
			if (value && _callback is Function) {
				_callback.apply(null, _parameter);
			}
		}
		
		//子类继承，不同CD消除不同
		protected function kill_self():void
		{
			
		}
		
		//ends
	}
}