package org.web.sdk.tool 
{
	import flash.utils.getTimer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	//一个非常好的矩形CD进度时间显示器
	public class CoolTime extends Sprite 
	{
		//开始时间
		private var startTime:Number = 0;
		//cd时间
		private var cdtime:Number = 1000;
		//基本数据
		private var W:Number = 50;
		private var H:Number = 50;
		private var LENG:Number = 0;
		private var section:Array;
		//结束回调
		private var endCalled:Function;
		//颜色
		private const lineColor:uint = 0xff0000;
		private const brackColor:uint = 0x666666;
		//
		private var onCompleteArgs:Array;
		
		public function CoolTime(sizew:int = 50, sizeh:int = 50)
		{
			W = sizew;
			H = sizeh;
			LENG = 2 * (W + H);
			section = [W / 2, W / 2 + H, W / 2 + H + W, W / 2 + H + W + H, W + H + W + H];
		}
		
		//cd开始  结束之后会自动移除
		public function coolDown(cdtime:Number, runTime:Number = 0, called:Function = null, ...args):void
		{
			this.onCompleteArgs = args;
			this.cdtime = cdtime * 1000;						//这里用秒计时
			this.endCalled = called; 							//回调
			this.startTime = getTimer() - runTime * 1000;		//开始时间  runTime流失的时间
			initMask();											//初始化绘制
			this.removeEventListener(Event.ENTER_FRAME,onEnter);
			this.addEventListener(Event.ENTER_FRAME,onEnter);
		}
		
		//初始绘制
		private function initMask():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,lineColor);
			this.graphics.beginFill(brackColor);
			this.graphics.drawRect(0, 0, W, H);
			this.graphics.endFill();
		}
		
		/*我们将他分为5段，这样才能正确绘制出来*/
		private function showMask(middlex:Number,middley:Number,step:int=0):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(0,lineColor);
			this.graphics.beginFill(brackColor);
			this.graphics.moveTo(W >> 1, 0);
			this.graphics.lineTo(W >> 1, H >> 1);
			this.graphics.lineTo(middlex, middley);
			//绘制分段
			if(step<=0) this.graphics.lineTo(W , 0);
			if(step<=1) this.graphics.lineTo(W , H);
			if(step<=2) this.graphics.lineTo(0 , H);
			if(step<=3) this.graphics.lineTo(0 , 0);
			if(step<=4) this.graphics.lineTo(W>>1 , 0);
		}

		private function onEnter(e:Event):void
		{
			var time:Number = (getTimer() - startTime) / cdtime;
			gradually(time * LENG | 0);
		}
		
		//通过长度 直接绘制
		private function gradually(leng:int, isbreak:Boolean = true):void
		{
			if(leng > LENG) leng = LENG;
			var index:int = 0;
			var middle:Point;
			while(index < section.length){
				if(section[index] >= leng){
					middle = middleLocation(leng,index);
					showMask(middle.x,middle.y,index);
					break;
				}
				++index;
			}
			if (leng == LENG) {
				this.removeEventListener(Event.ENTER_FRAME, onEnter);
				if (this.parent) this.parent.removeChild(this);
				if (isbreak && endCalled is Function) endCalled.apply(null, onCompleteArgs);
			}
		}

		private function middleLocation(leng:Number,step:int=0):Point
		{
			switch(step)
			{
				case 0: return new Point((W >> 1) + leng, 0);
				case 1: return new Point(W, leng - section[step - 1]);
				case 2: return new Point(W - (leng - section[step - 1]), H);
				case 3: return new Point(0, H - (leng - section[step - 1]));
				case 4: return new Point(leng - section[step - 1], 0);
			}
			return new Point(W >> 1, H >> 1);
		}

		//直接调用消除cd
		public function kill():void
		{
			gradually(LENG, false);
		}
		
		//ends
	}
}